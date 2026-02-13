package com.colourswift.cssecurity.vpn

import android.net.VpnService
import android.os.ParcelFileDescriptor
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.delay
import java.io.FileInputStream
import java.io.FileOutputStream
import java.net.DatagramPacket
import java.net.DatagramSocket
import java.net.InetSocketAddress
import java.net.SocketTimeoutException
import java.nio.ByteBuffer
import kotlinx.coroutines.isActive
import com.colourswift.cssecurity.AppWifiRules
import com.colourswift.cssecurity.CsDnsEvents

object CsvpnTunnelLoop {

    suspend fun run(
        service: VpnService,
        tun: ParcelFileDescriptor?,
        shouldStop: () -> Boolean,
        fakeDnsIp: String,
        cloudResolve: (ByteArray, String?) -> Pair<ByteArray?, Map<String, Any?>?>
    ) {
        val fd = tun?.fileDescriptor ?: return
        val input = FileInputStream(fd).channel
        val output = FileOutputStream(fd).channel
        val buf = ByteBuffer.allocate(65535)

        val dnsSocket = DatagramSocket()
        dnsSocket.soTimeout = 3000
        service.protect(dnsSocket)

        val ctx = service.applicationContext

        while (!shouldStop() && (service as? CoroutineScope)?.isActive != false) {
            buf.clear()
            val n = try {
                input.read(buf)
            } catch (_: Exception) {
                break
            }

            if (n <= 0) {
                delay(5)
                continue
            }

            buf.flip()
            val packet = ByteArray(n)
            buf.get(packet)

            if (!DnsPacketUtils.isIpv4Udp(packet) || !DnsPacketUtils.isDnsToFakeServer(packet, fakeDnsIp)) {
                continue
            }

            try {
                val dnsQuery = DnsPacketUtils.extractDnsPayload(packet) ?: continue
                val domain = DnsPacketUtils.extractDomain(packet)

                if (domain != null && domain.equals("dns.colourswift.com", ignoreCase = true)) {
                    val upstream = InetSocketAddress(CsvpnCloudPrefs.cloudResolverIp(ctx), 53)
                    val upstreamPacket = DatagramPacket(dnsQuery, dnsQuery.size, upstream)
                    dnsSocket.send(upstreamPacket)

                    val recv = ByteArray(4096)
                    val replyPacket = DatagramPacket(recv, recv.size)
                    try {
                        dnsSocket.receive(replyPacket)
                    } catch (_: SocketTimeoutException) {
                        continue
                    }

                    val dnsReply = replyPacket.data.copyOf(replyPacket.length)
                    val rebuilt = DnsPacketUtils.rebuildDnsReply(packet, dnsReply)
                    output.write(ByteBuffer.wrap(rebuilt))
                    continue
                }

                val uid = lookupUidForDnsPacket(packet)
                if (uid != null && AppWifiRules.shouldBlockUidOnWifi(ctx, uid)) {
                    val blockedReply = DnsPacketUtils.buildNxDomain(dnsQuery) ?: continue
                    val rebuilt = DnsPacketUtils.rebuildDnsReply(packet, blockedReply)
                    output.write(ByteBuffer.wrap(rebuilt))

                    try {
                        CsDnsEvents.emit(
                            mapOf(
                                "ts_ms" to System.currentTimeMillis(),
                                "qname" to (domain ?: "unknown"),
                                "blocked" to true,
                                "plan" to CsvpnCloudPrefs.cloudPlan(ctx),
                                "upstream" to null,
                                "latency_ms" to 0,
                                "decision" to mapOf(
                                    "match" to mapOf(
                                        "list" to "wifi_app_block",
                                        "type" to "app_rule"
                                    )
                                )
                            )
                        )
                    } catch (_: Exception) {
                    }

                    continue
                }

                CsvpnUsage.bumpUsageCount(ctx)
                val (dnsReply, meta) = cloudResolve(dnsQuery, domain)
                if (meta != null) {
                    try {
                        CsDnsEvents.emit(meta)
                    } catch (_: Exception) {
                    }
                }
                if (dnsReply != null) {
                    val rebuilt = DnsPacketUtils.rebuildDnsReply(packet, dnsReply)
                    output.write(ByteBuffer.wrap(rebuilt))
                    continue
                }

                val upstream = InetSocketAddress(CsvpnCloudPrefs.cloudResolverIp(ctx), 53)
                val upstreamPacket = DatagramPacket(dnsQuery, dnsQuery.size, upstream)
                dnsSocket.send(upstreamPacket)

                val recv = ByteArray(4096)
                val replyPacket = DatagramPacket(recv, recv.size)
                try {
                    dnsSocket.receive(replyPacket)
                } catch (_: SocketTimeoutException) {
                    continue
                }

                val dnsFallbackReply = replyPacket.data.copyOf(replyPacket.length)
                val rebuiltFallback = DnsPacketUtils.rebuildDnsReply(packet, dnsFallbackReply)
                output.write(ByteBuffer.wrap(rebuiltFallback))
            } catch (_: Exception) {
            }
        }

        try {
            dnsSocket.close()
        } catch (_: Exception) {
        }
    }

    private fun lookupUidForDnsPacket(ipv4UdpPacket: ByteArray): Int? {
        val ihl = DnsPacketUtils.ipHeaderLength(ipv4UdpPacket)
        if (ipv4UdpPacket.size < ihl + 8) return null
        val srcPort = ((ipv4UdpPacket[ihl].toInt() and 0xFF) shl 8) or (ipv4UdpPacket[ihl + 1].toInt() and 0xFF)
        if (srcPort <= 0) return null
        return ProcNetUid.lookupUdpUid(srcPort)
    }
}
