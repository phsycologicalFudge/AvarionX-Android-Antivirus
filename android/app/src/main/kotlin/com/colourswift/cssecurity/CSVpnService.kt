package com.colourswift.cssecurity

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.net.VpnService
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.os.ParcelFileDescriptor
import android.util.Log
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.isActive
import kotlinx.coroutines.launch
import java.io.FileInputStream
import java.io.FileOutputStream
import java.net.DatagramPacket
import java.net.DatagramSocket
import java.net.InetSocketAddress
import java.net.SocketTimeoutException
import java.nio.ByteBuffer
import java.util.concurrent.CountDownLatch

object CsvpnBridge {
    @Volatile
    private var engine: FlutterEngine? = null

    fun ensureEngine(context: Context) {
        if (engine != null) return
        synchronized(this) {
            if (engine != null) return

            val latch = CountDownLatch(1)
            val appContext = context.applicationContext

            Handler(Looper.getMainLooper()).post {
                try {
                    val loader = FlutterInjector.instance().flutterLoader()
                    loader.ensureInitializationComplete(appContext, null)

                    val fe = FlutterEngine(appContext)
                    val entry = DartExecutor.DartEntrypoint(
                        loader.findAppBundlePath(),
                        "vpnMain"
                    )
                    fe.dartExecutor.executeDartEntrypoint(entry)
                    engine = fe
                } finally {
                    latch.countDown()
                }
            }

            latch.await()
        }
    }

    fun channel(context: Context): MethodChannel {
        ensureEngine(context)
        return MethodChannel(engine!!.dartExecutor.binaryMessenger, "cs_vpn_channel")
    }
}

class CSVpnService : VpnService() {

    private var tun: ParcelFileDescriptor? = null
    private val scope = CoroutineScope(Dispatchers.IO)

    private val fakeDnsIp = "10.0.0.1"
    private val tunIp = "10.0.0.2"
    private val upstreamDns = InetSocketAddress("1.1.1.1", 53)

    @Volatile
    private var shouldStop = false

    override fun onCreate() {
        super.onCreate()
        startForegroundNotif()
        startTunnel()
    }

    private fun startForegroundNotif() {
        val id = "cs_vpn_channel"
        val mgr = getSystemService(NotificationManager::class.java)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val ch = NotificationChannel(id, "CS Network Protection", NotificationManager.IMPORTANCE_LOW)
            mgr.createNotificationChannel(ch)
        }

        val pi = PendingIntent.getActivity(
            this, 0,
            Intent(this, MainActivity::class.java),
            PendingIntent.FLAG_IMMUTABLE
        )

        val n = Notification.Builder(this, id)
            .setContentTitle("Network Protection Active")
            .setContentText("Scanning DNS requests")
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentIntent(pi)
            .setOngoing(true)
            .build()

        startForeground(200, n)
    }

    private fun startTunnel() {
        shouldStop = false

        val builder = Builder()
            .setSession("CS DNS Protection")
            .addAddress(tunIp, 32)
            .addDnsServer(fakeDnsIp)
            .addRoute(fakeDnsIp, 32)

        tun = builder.establish()

        if (tun == null) {
            stopSelf()
            return
        }

        scope.launch {
            runTunnelLoop()
        }
    }

    private suspend fun CoroutineScope.runTunnelLoop() {
        val fd = tun?.fileDescriptor ?: return
        val input = FileInputStream(fd).channel
        val output = FileOutputStream(fd).channel
        val buf = ByteBuffer.allocate(65535)

        val dnsSocket = DatagramSocket()
        dnsSocket.soTimeout = 3000
        protect(dnsSocket)

        while (!shouldStop && isActive) {
            buf.clear()
            val n = input.read(buf)
            if (n <= 0) continue
            buf.flip()

            val packet = ByteArray(n)
            buf.get(packet)

            if (!isIpv4Udp(packet)) {
                output.write(ByteBuffer.wrap(packet))
                continue
            }

            if (!isDnsToFakeServer(packet)) {
                output.write(ByteBuffer.wrap(packet))
                continue
            }

            try {
                val domain = extractDomain(packet)

                val dnsQuery1 = extractDnsPayload(packet)
                if (dnsQuery1 == null) {
                    output.write(ByteBuffer.wrap(packet))
                    continue
                }

                if (domain != null && shouldBlockDomain(domain)) {
                    val nx = buildNxDomainPayload(dnsQuery1)
                    val nxReply = rebuildDnsReply(packet, nx)
                    output.write(ByteBuffer.wrap(nxReply))
                    continue
                }

                val dnsQuery2 = extractDnsPayload(packet)
                if (dnsQuery2 == null) {
                    output.write(ByteBuffer.wrap(packet))
                    continue
                }

                val upstreamPacket = DatagramPacket(dnsQuery2, dnsQuery2.size, upstreamDns)
                dnsSocket.send(upstreamPacket)

                val recv = ByteArray(4096)
                val replyPacket = DatagramPacket(recv, recv.size)

                try {
                    dnsSocket.receive(replyPacket)
                } catch (toe: SocketTimeoutException) {
                    output.write(ByteBuffer.wrap(packet))
                    continue
                }

                val dnsReply = replyPacket.data.copyOf(replyPacket.length)
                val rebuilt = rebuildDnsReply(packet, dnsReply)
                output.write(ByteBuffer.wrap(rebuilt))
            }
            catch (e: Exception) {
                Log.e("CSVPN", "DNS error: ${e.message}", e)
                output.write(ByteBuffer.wrap(packet))
            }
        }

        dnsSocket.close()
    }

    private fun isIpv4Udp(d: ByteArray): Boolean {
        if (d.size < 28) return false
        val v = (d[0].toInt() ushr 4) and 0xF
        if (v != 4) return false
        return (d[9].toInt() and 0xFF) == 17
    }

    private fun ipHeaderLength(d: ByteArray): Int {
        return (d[0].toInt() and 0x0F) * 4
    }

    private fun isDnsToFakeServer(d: ByteArray): Boolean {
        val ihl = ipHeaderLength(d)
        if (d.size < ihl + 8) return false

        val dstIp = ((d[16].toInt() and 0xFF) shl 24) or
                ((d[17].toInt() and 0xFF) shl 16) or
                ((d[18].toInt() and 0xFF) shl 8) or
                (d[19].toInt() and 0xFF)

        val parts = fakeDnsIp.split(".").map { it.toInt() }
        val fakeInt = (parts[0] shl 24) or (parts[1] shl 16) or (parts[2] shl 8) or parts[3]

        val dstPort = ((d[ihl + 2].toInt() and 0xFF) shl 8) or (d[ihl + 3].toInt() and 0xFF)

        return dstIp == fakeInt && dstPort == 53
    }

    private fun extractDnsPayload(d: ByteArray): ByteArray? {
        val ihl = ipHeaderLength(d)
        if (d.size < ihl + 8 + 12) return null

        val totalLen = ((d[2].toInt() and 0xFF) shl 8) or (d[3].toInt() and 0xFF)
        val udpLen = ((d[ihl + 4].toInt() and 0xFF) shl 8) or (d[ihl + 5].toInt() and 0xFF)
        if (totalLen < ihl + udpLen) return null

        val dnsStart = ihl + 8
        val dnsLen = udpLen - 8
        if (dnsStart + dnsLen > d.size) return null

        return d.copyOfRange(dnsStart, dnsStart + dnsLen)
    }

    private fun extractDomain(d: ByteArray): String? {
        val dnsPayload = extractDnsPayload(d) ?: return null
        if (dnsPayload.size < 12) return null

        var off = 12
        val labels = ArrayList<String>()

        while (off < dnsPayload.size) {
            val len = dnsPayload[off].toInt() and 0xFF
            if (len == 0) break
            if ((len and 0xC0) == 0xC0) break
            if (off + 1 + len > dnsPayload.size) return null

            labels.add(String(dnsPayload, off + 1, len, Charsets.US_ASCII))
            off += 1 + len
        }

        if (labels.isEmpty()) return null
        return normalizeHost(labels.joinToString("."))
    }

    private fun normalizeHost(h: String): String {
        var t = h.trim().lowercase()
        if (t.endsWith(".")) t = t.dropLast(1)
        if (t.startsWith("www.")) t = t.substring(4)
        return t
    }

    private fun shouldBlockDomain(domain: String): Boolean {
        return try {
            val channel = CsvpnBridge.channel(applicationContext)
            val result = channel.invokeMethod(
                "checkConnection",
                mapOf(
                    "ip" to domain,
                    "sni" to domain,
                    "port" to 443
                )
            ) as Int
            result != 0
        } catch (_: Exception) {
            false
        }
    }

    private fun buildNxDomainPayload(query: ByteArray): ByteArray {
        if (query.size < 12) return query
        val resp = query.copyOf()
        resp[2] = (resp[2].toInt() or 0x80 or 0x04).toByte()
        resp[3] = ((resp[3].toInt() and 0xF0) or 0x03).toByte()
        return resp
    }

    private fun rebuildDnsReply(original: ByteArray, dnsReply: ByteArray): ByteArray {
        val ihl = ipHeaderLength(original)
        val udpOff = ihl

        val clientIp = original.copyOfRange(12, 16)
        val fakeIp = original.copyOfRange(16, 20)

        val clientPort = (((original[udpOff].toInt() and 0xFF) shl 8)
                or (original[udpOff + 1].toInt() and 0xFF))

        val serverPort = (((original[udpOff + 2].toInt() and 0xFF) shl 8)
                or (original[udpOff + 3].toInt() and 0xFF))

        val totalLen = ihl + 8 + dnsReply.size
        val out = ByteArray(totalLen)

        System.arraycopy(original, 0, out, 0, ihl)

        out[2] = ((totalLen shr 8) and 0xFF).toByte()
        out[3] = (totalLen and 0xFF).toByte()

        out[12] = fakeIp[0]
        out[13] = fakeIp[1]
        out[14] = fakeIp[2]
        out[15] = fakeIp[3]

        out[16] = clientIp[0]
        out[17] = clientIp[1]
        out[18] = clientIp[2]
        out[19] = clientIp[3]

        out[udpOff] = (serverPort shr 8).toByte()
        out[udpOff + 1] = (serverPort and 0xFF).toByte()

        out[udpOff + 2] = (clientPort shr 8).toByte()
        out[udpOff + 3] = (clientPort and 0xFF).toByte()

        val udpLen = 8 + dnsReply.size
        out[udpOff + 4] = ((udpLen shr 8) and 0xFF).toByte()
        out[udpOff + 5] = (udpLen and 0xFF).toByte()

        out[udpOff + 6] = 0
        out[udpOff + 7] = 0

        val dnsStart = ihl + 8
        System.arraycopy(dnsReply, 0, out, dnsStart, dnsReply.size)

        out[10] = 0
        out[11] = 0
        val ipSum = ipv4Checksum(out, 0, ihl)
        out[10] = ((ipSum shr 8) and 0xFF).toByte()
        out[11] = (ipSum and 0xFF).toByte()

        val udpSum = udpChecksum(out, udpOff, udpLen)
        out[udpOff + 6] = ((udpSum shr 8) and 0xFF).toByte()
        out[udpOff + 7] = (udpSum and 0xFF).toByte()

        return out
    }

    private fun ipv4Checksum(d: ByteArray, off: Int, len: Int): Int {
        var sum = 0L
        var i = 0
        while (i < len) {
            val w = ((d[off + i].toInt() and 0xFF) shl 8) or (d[off + i + 1].toInt() and 0xFF)
            sum += w
            i += 2
        }
        while (sum shr 16 != 0L) sum = (sum and 0xFFFF) + (sum shr 16)
        return (sum.inv() and 0xFFFF).toInt()
    }

    private fun udpChecksum(d: ByteArray, udpOff: Int, udpLen: Int): Int {
        val src = ((d[12].toInt() and 0xFF) shl 24) or
                ((d[13].toInt() and 0xFF) shl 16) or
                ((d[14].toInt() and 0xFF) shl 8) or
                (d[15].toInt() and 0xFF)

        val dst = ((d[16].toInt() and 0xFF) shl 24) or
                ((d[17].toInt() and 0xFF) shl 16) or
                ((d[18].toInt() and 0xFF) shl 8) or
                (d[19].toInt() and 0xFF)

        var sum = 0L
        sum += (src shr 16) and 0xFFFF
        sum += src and 0xFFFF
        sum += (dst shr 16) and 0xFFFF
        sum += dst and 0xFFFF
        sum += 17
        sum += udpLen.toLong()

        var i = 0
        while (i < udpLen) {
            val b1 = d[udpOff + i].toInt() and 0xFF
            val b2 = if (i + 1 < udpLen) d[udpOff + i + 1].toInt() and 0xFF else 0
            sum += ((b1 shl 8) or b2)
            i += 2
        }

        while (sum shr 16 != 0L) sum = (sum and 0xFFFF) + (sum shr 16)
        val out = (sum.inv() and 0xFFFF).toInt()
        return if (out == 0) 0xFFFF else out
    }

    override fun onDestroy() {
        shouldStop = true
        try { tun?.close() } catch (_: Exception) {}
        tun = null
        stopForeground(true)
        super.onDestroy()
    }
}
