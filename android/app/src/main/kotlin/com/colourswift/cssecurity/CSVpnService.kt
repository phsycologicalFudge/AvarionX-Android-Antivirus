package com.colourswift.cssecurity

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.net.VpnService
import android.os.Build
import android.os.ParcelFileDescriptor
import android.util.Base64
import android.util.Log
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.delay
import kotlinx.coroutines.isActive
import kotlinx.coroutines.launch
import kotlinx.coroutines.cancel
import org.json.JSONObject
import java.io.FileInputStream
import java.io.FileOutputStream
import java.net.DatagramPacket
import java.net.DatagramSocket
import java.net.HttpURLConnection
import java.net.InetSocketAddress
import java.net.SocketTimeoutException
import java.net.URL
import java.nio.ByteBuffer
import android.net.ConnectivityManager
import android.net.NetworkCapabilities

class CSVpnService : VpnService() {

    companion object {
        const val ACTION_START = "com.colourswift.cssecurity.VPN_START"
        const val ACTION_STOP = "com.colourswift.cssecurity.VPN_STOP"
        const val NOTIF_ID = 200

        private const val PROTECTION_CHANNEL_ID = "cssecurity_realtime_v2"
        private const val GROUP_KEY = "cssecurity_protection_group"
        private const val SUMMARY_ID = 2

        private const val PREFS = "cs_dns_cloud"
        private const val PREF_CLOUD_ENABLED_LISTS = "enabled_lists_json"
        private const val PREF_CLOUD_RESOLVER = "resolver"
        private const val PREF_CLOUD_PLAN = "plan"
        private const val PREF_CLOUD_URL = "cloud_url"
        private const val PREF_CLIENT_ID = "client_id"

        private const val DEFAULT_CLOUD_URL = "https://dns.colourswift.com/resolve"
        private const val DEFAULT_UPSTREAM_FREE = "1.1.1.2"
        private const val DEFAULT_UPSTREAM_ADULT = "1.1.1.3"
    }

    private var tun: ParcelFileDescriptor? = null
    private val scope = CoroutineScope(Dispatchers.IO + SupervisorJob())
    private var tunnelJob: kotlinx.coroutines.Job? = null

    private val fakeDnsIp = "10.0.0.1"
    private val tunIp = "10.0.0.2"

    private enum class Mode {
        BASIC_MALWARE,
        BASIC_ADULT,
        CLOUD
    }

    @Volatile
    private var mode: Mode = Mode.BASIC_MALWARE

    @Volatile
    private var shouldStop = false

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val action = intent?.action
        val rawMode = intent?.getStringExtra("dns_mode")
        Log.i("CSVpn", "onStartCommand action=$action dns_mode=$rawMode oldMode=$mode")

        if (action == ACTION_STOP) {
            stopTunnel()
            stopSelf()
            return START_NOT_STICKY
        }

        val m = rawMode?.trim()?.lowercase()
        mode = when (m) {
            "basic_malware", "malware" -> {
                Log.i("CSVpn", "onStartCommand setting mode=BASIC_MALWARE (raw=$m)")
                Mode.BASIC_MALWARE
            }
            "basic_adult", "adult" -> {
                Log.i("CSVpn", "onStartCommand setting mode=BASIC_ADULT (raw=$m)")
                Mode.BASIC_ADULT
            }
            "cloud" -> {
                Log.i("CSVpn", "onStartCommand setting mode=CLOUD")
                Mode.CLOUD
            }
            null -> {
                Log.i("CSVpn", "onStartCommand with null dns_mode, keeping existing mode=$mode")
                mode
            }
            else -> {
                Log.i("CSVpn", "onStartCommand unknown dns_mode=$m, defaulting to BASIC_MALWARE")
                Mode.BASIC_MALWARE
            }
        }

        startForegroundNotif()
        startTunnel()
        return START_STICKY
    }
    private fun ensureProtectionChannel(mgr: NotificationManager) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val ch = NotificationChannel(
                PROTECTION_CHANNEL_ID,
                "Protection",
                NotificationManager.IMPORTANCE_LOW
            )
            ch.setShowBadge(false)
            mgr.createNotificationChannel(ch)
        }
    }

    private fun buildSummaryNotification(pi: PendingIntent): Notification {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(this, PROTECTION_CHANNEL_ID)
                .setContentTitle("AVarionX")
                .setContentText("Protection active")
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentIntent(pi)
                .setOnlyAlertOnce(true)
                .setGroup(GROUP_KEY)
                .setGroupSummary(true)
                .build()
        } else {
            Notification.Builder(this)
                .setContentTitle("AVarionX")
                .setContentText("Protection active")
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentIntent(pi)
                .setOnlyAlertOnce(true)
                .setGroup(GROUP_KEY)
                .setGroupSummary(true)
                .build()
        }
    }

    private fun buildVpnNotification(pi: PendingIntent): Notification {
        val title = if (mode == Mode.CLOUD) "Cloud Protection Active" else "Network Protection Active"
        val text = if (mode == Mode.CLOUD) "DNS Protection" else "DNS Protection"
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(this, PROTECTION_CHANNEL_ID)
                .setContentTitle(title)
                .setContentText(text)
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentIntent(pi)
                .setOngoing(true)
                .setOnlyAlertOnce(true)
                .setGroup(GROUP_KEY)
                .build()
        } else {
            Notification.Builder(this)
                .setContentTitle(title)
                .setContentText(text)
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentIntent(pi)
                .setOngoing(true)
                .setOnlyAlertOnce(true)
                .setGroup(GROUP_KEY)
                .build()
        }
    }

    private fun startForegroundNotif() {
        val mgr = getSystemService(NotificationManager::class.java)
        ensureProtectionChannel(mgr)

        val pi = PendingIntent.getActivity(
            this, 0,
            Intent(this, MainActivity::class.java),
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )

        mgr.notify(SUMMARY_ID, buildSummaryNotification(pi))
        val n = buildVpnNotification(pi)
        Log.i("CSVpn", "Starting foreground with notification, mode=$mode")
        startForeground(NOTIF_ID, n)
    }

    private fun startTunnel() {
        if (tun != null) {
            Log.i("CSVpn", "startTunnel called but tun already exists, mode=$mode")
            return
        }

        shouldStop = false

        val builder = Builder()
            .setSession("CS DNS Protection")
            .addAddress(tunIp, 32)
            .addDnsServer(fakeDnsIp)
            .addRoute(fakeDnsIp, 32)

        Log.i("CSVpn", "Establishing TUN with tunIp=$tunIp fakeDnsIp=$fakeDnsIp")
        tun = builder.establish()

        if (tun == null) {
            Log.e("CSVpn", "Failed to establish TUN")
            stopSelf()
            return
        }

        tunnelJob?.cancel()
        tunnelJob = scope.launch {
            Log.i("CSVpn", "runTunnelLoop starting, initial mode=$mode")
            runTunnelLoop()
            Log.i("CSVpn", "runTunnelLoop exited")
        }

        Log.i("CSVpn", "Tunnel started, mode=$mode")
    }

    private fun stopTunnel() {
        Log.i("CSVpn", "stopTunnel called")
        shouldStop = true

        try {
            tun?.close()
        } catch (_: Exception) {
        }
        tun = null

        tunnelJob?.cancel()
        tunnelJob = null

        try {
            stopForeground(true)
        } catch (_: Exception) {
        }

        scope.cancel()
        Log.i("CSVpn", "Tunnel stopped, scope cancelled")
    }

    private fun cloudPrefs(): android.content.SharedPreferences {
        return applicationContext.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
    }

    private fun cloudUrl(): String {
        val v = cloudPrefs().getString(PREF_CLOUD_URL, null)
        val s = v?.trim().orEmpty()
        val url = if (s.isNotEmpty()) s else DEFAULT_CLOUD_URL
        Log.i("CSVpn", "cloudUrl() -> $url")
        return url
    }

    private fun cloudPlan(): String {
        val v = cloudPrefs().getString(PREF_CLOUD_PLAN, null)
        val s = v?.trim()?.lowercase().orEmpty()
        val plan = if (s == "pro") "pro" else "free"
        Log.i("CSVpn", "cloudPlan() -> $plan (raw=$v)")
        return plan
    }

    private fun cloudClientId(): String? {
        val v = cloudPrefs().getString(PREF_CLIENT_ID, null)
        val s = v?.trim().orEmpty()
        val id = if (s.isNotEmpty()) s else null
        Log.i("CSVpn", "cloudClientId() -> $id")
        return id
    }

    private fun cloudSettingsB64(): String? {
        val listsJson = cloudPrefs().getString(PREF_CLOUD_ENABLED_LISTS, null)
        val resolver = cloudPrefs().getString(PREF_CLOUD_RESOLVER, null)

        val obj = JSONObject()

        if (!listsJson.isNullOrBlank()) {
            try {
                obj.put("enabled_lists", org.json.JSONArray(listsJson))
            } catch (_: Exception) {
            }
        }

        val r = resolver?.trim().orEmpty()
        if (r.isNotEmpty()) {
            obj.put("resolver", r)
        }

        if (obj.length() == 0) {
            Log.i("CSVpn", "cloudSettingsB64() no settings to send")
            return null
        }
        val raw = obj.toString().toByteArray(Charsets.UTF_8)
        val out = Base64.encodeToString(raw, Base64.NO_WRAP)
        Log.i("CSVpn", "cloudSettingsB64() built payload=${obj.toString()} length=${raw.size}")
        return out
    }

    private fun openCloudHttp(url: String): HttpURLConnection {
        val cm = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager

        val network = cm.allNetworks.firstOrNull { n ->
            val caps = cm.getNetworkCapabilities(n) ?: return@firstOrNull false
            caps.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET) &&
                    caps.hasCapability(NetworkCapabilities.NET_CAPABILITY_NOT_VPN) &&
                    (caps.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) ||
                            caps.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) ||
                            caps.hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET))
        }

        val u = URL(url)
        val conn = if (network != null) network.openConnection(u) else u.openConnection()
        return conn as HttpURLConnection
    }
    private fun cloudResolverIp(): String {
        val v = cloudPrefs().getString(PREF_CLOUD_RESOLVER, null)
        val s = v?.trim().orEmpty()
        val ip = if (s.isNotEmpty()) s else "1.1.1.1"
        Log.i("CSVpn", "cloudResolverIp() -> $ip")
        return ip
    }

    private fun basicUpstream(): InetSocketAddress {
        val target = when (mode) {
            Mode.BASIC_MALWARE -> InetSocketAddress(DEFAULT_UPSTREAM_FREE, 53)
            Mode.BASIC_ADULT -> InetSocketAddress(DEFAULT_UPSTREAM_ADULT, 53)
            Mode.CLOUD -> InetSocketAddress(cloudResolverIp(), 53)
        }
        Log.i("CSVpn", "basicUpstream() mode=$mode -> $target")
        return target
    }

    private fun cloudResolve(dnsQuery: ByteArray, qname: String?): Pair<ByteArray?, Map<String, Any?>?> {
        val url = cloudUrl()
        val plan = cloudPlan()
        val clientId = cloudClientId()
        val settingsB64 = cloudSettingsB64()

        Log.i("CSVpn", "cloudResolve() start url=$url plan=$plan qname=$qname settingsPresent=${settingsB64 != null}")

        val bodyObj = JSONObject()
        bodyObj.put("dns_b64", Base64.encodeToString(dnsQuery, Base64.NO_WRAP))
        if (settingsB64 != null) bodyObj.put("settings_b64", settingsB64)
        val bodyBytes = bodyObj.toString().toByteArray(Charsets.UTF_8)

        val start = System.nanoTime()

        try {
            val conn = openCloudHttp(url)
            conn.requestMethod = "POST"
            conn.connectTimeout = 3000
            conn.readTimeout = 3500
            conn.doOutput = true
            conn.setRequestProperty("Content-Type", "application/json")
            conn.setRequestProperty("x-plan", plan)
            if (clientId != null) conn.setRequestProperty("x-client-id", clientId)

            Log.i("CSVpn", "cloudResolve() sending HTTP POST, bodyLen=${bodyBytes.size}")
            conn.outputStream.use { it.write(bodyBytes) }

            val code = conn.responseCode
            Log.i("CSVpn", "cloudResolve() HTTP status=$code")
            val stream = if (code in 200..299) conn.inputStream else conn.errorStream
            val raw = stream?.readBytes() ?: ByteArray(0)
            Log.i("CSVpn", "cloudResolve() HTTP bodyLen=${raw.size}")
            if (raw.isEmpty()) return Pair(null, null)

            val respJson = JSONObject(String(raw, Charsets.UTF_8))
            val dnsB64 = respJson.optString("dns_b64", null) ?: return Pair(null, null)
            val meta = respJson.optJSONObject("meta")

            val dnsReply = Base64.decode(dnsB64, Base64.DEFAULT)

            val metaMap = mutableMapOf<String, Any?>()
            metaMap["ts_ms"] = meta?.optLong("ts_ms", System.currentTimeMillis()) ?: System.currentTimeMillis()
            metaMap["qname"] = meta?.optString("qname", qname ?: "unknown") ?: (qname ?: "unknown")
            metaMap["blocked"] = meta?.optBoolean("blocked", false) ?: false
            metaMap["plan"] = meta?.optString("plan", plan) ?: plan
            metaMap["upstream"] = meta?.optString("upstream", null)
            metaMap["latency_ms"] = meta?.optInt("latency_ms", -1)?.let { if (it >= 0) it else null }
                ?: ((System.nanoTime() - start) / 1_000_000L).toInt()

            val decision = meta?.optJSONObject("decision")
            if (decision != null) {
                val match = decision.optJSONObject("match")
                metaMap["decision"] = mapOf(
                    "match" to if (match != null) mapOf(
                        "list" to match.optString("list", null),
                        "type" to match.optString("type", null)
                    ) else null
                )
            } else {
                metaMap["decision"] = mapOf("match" to null)
            }

            Log.i("CSVpn", "cloudResolve() success blocked=${metaMap["blocked"]} latency=${metaMap["latency_ms"]}")
            return Pair(dnsReply, metaMap)
        } catch (e: Exception) {
            val latencyMs = ((System.nanoTime() - start) / 1_000_000L).toInt()
            Log.e("CSVpn", "cloudResolve() error: ${e.message}", e)
            val metaMap = mapOf(
                "ts_ms" to System.currentTimeMillis(),
                "qname" to (qname ?: "unknown"),
                "blocked" to false,
                "plan" to plan,
                "upstream" to null,
                "latency_ms" to latencyMs,
                "decision" to mapOf("match" to null)
            )
            return Pair(null, metaMap)
        }
    }

    private suspend fun runTunnelLoop() {
        val fd = tun?.fileDescriptor ?: run {
            Log.e("CSVpn", "runTunnelLoop: tun.fileDescriptor is null, aborting")
            return
        }
        val input = FileInputStream(fd).channel
        val output = FileOutputStream(fd).channel
        val buf = ByteBuffer.allocate(65535)

        val dnsSocket = DatagramSocket()
        dnsSocket.soTimeout = 3000
        protect(dnsSocket)
        Log.i("CSVpn", "runTunnelLoop: DNS socket created and protected, mode=$mode")

        while (!shouldStop && scope.isActive) {
            buf.clear()
            val n = try {
                input.read(buf)
            } catch (e: Exception) {
                Log.e("CSVpn", "runTunnelLoop: error reading from TUN: ${e.message}", e)
                break
            }

            if (n <= 0) {
                delay(5)
                continue
            }

            buf.flip()
            val packet = ByteArray(n)
            buf.get(packet)

            if (!isIpv4Udp(packet) || !isDnsToFakeServer(packet)) {
                try {
                    output.write(ByteBuffer.wrap(packet))
                } catch (_: Exception) {
                }
                continue
            }

            try {
                val domain = extractDomain(packet)
                val dnsQuery = extractDnsPayload(packet)

                Log.i("CSVpn", "runTunnelLoop: intercepted DNS qname=$domain len=${dnsQuery?.size ?: 0} mode=$mode")

                if (dnsQuery == null) {
                    try {
                        output.write(ByteBuffer.wrap(packet))
                    } catch (_: Exception) {
                    }
                    continue
                }

                if (mode == Mode.CLOUD) {
                    if (domain != null && domain.equals("dns.colourswift.com", ignoreCase = true)) {
                        Log.i("CSVpn", "runTunnelLoop: special handling for resolver host, using UDP upstream only for qname=$domain")
                        val upstream = InetSocketAddress(cloudResolverIp(), 53)
                        val upstreamPacket = DatagramPacket(dnsQuery, dnsQuery.size, upstream)
                        dnsSocket.send(upstreamPacket)

                        val recv = ByteArray(4096)
                        val replyPacket = DatagramPacket(recv, recv.size)
                        try {
                            dnsSocket.receive(replyPacket)
                        } catch (e: SocketTimeoutException) {
                            Log.e("CSVpn", "runTunnelLoop: UDP special-case timeout for qname=$domain")
                            output.write(ByteBuffer.wrap(packet))
                            continue
                        }

                        val dnsReply = replyPacket.data.copyOf(replyPacket.length)
                        Log.i("CSVpn", "runTunnelLoop: special-case UDP reply len=${dnsReply.size} for qname=$domain")
                        val rebuilt = rebuildDnsReply(packet, dnsReply)
                        output.write(ByteBuffer.wrap(rebuilt))
                        continue
                    }

                    Log.i("CSVpn", "runTunnelLoop: using cloudResolve for qname=$domain")
                    val (dnsReply, meta) = cloudResolve(dnsQuery, domain)
                    if (meta != null) {
                        try {
                            Log.i("CSVpn", "runTunnelLoop: emitting DNS meta to Flutter for qname=${meta["qname"]}")
                            CsDnsEvents.emit(meta)
                        } catch (e: Exception) {
                            Log.e("CSVpn", "runTunnelLoop: error emitting DNS meta: ${e.message}", e)
                        }
                    }
                    if (dnsReply != null) {
                        Log.i("CSVpn", "runTunnelLoop: got reply from cloud server for qname=$domain, sending to app")
                        val rebuilt = rebuildDnsReply(packet, dnsReply)
                        output.write(ByteBuffer.wrap(rebuilt))
                        continue
                    }

                    Log.i("CSVpn", "runTunnelLoop: cloudResolve no reply, falling back to UDP resolver")
                    val upstream = InetSocketAddress(cloudResolverIp(), 53)
                    val upstreamPacket = DatagramPacket(dnsQuery, dnsQuery.size, upstream)
                    dnsSocket.send(upstreamPacket)

                    val recv = ByteArray(4096)
                    val replyPacket = DatagramPacket(recv, recv.size)
                    try {
                        dnsSocket.receive(replyPacket)
                    } catch (e: SocketTimeoutException) {
                        Log.e("CSVpn", "runTunnelLoop: UDP fallback timed out for qname=$domain")
                        output.write(ByteBuffer.wrap(packet))
                        continue
                    }

                    val dnsFallbackReply = replyPacket.data.copyOf(replyPacket.length)
                    Log.i("CSVpn", "runTunnelLoop: UDP fallback reply len=${dnsFallbackReply.size} for qname=$domain")
                    val rebuiltFallback = rebuildDnsReply(packet, dnsFallbackReply)
                    output.write(ByteBuffer.wrap(rebuiltFallback))
                    continue
                }

                val upstream = basicUpstream()
                Log.i("CSVpn", "runTunnelLoop: basic mode, forwarding to $upstream qname=$domain")
                val upstreamPacket = DatagramPacket(dnsQuery, dnsQuery.size, upstream)
                dnsSocket.send(upstreamPacket)

                val recv = ByteArray(4096)
                val replyPacket = DatagramPacket(recv, recv.size)

                try {
                    dnsSocket.receive(replyPacket)
                } catch (e: SocketTimeoutException) {
                    Log.e("CSVpn", "runTunnelLoop: basic UDP timeout for qname=$domain")
                    output.write(ByteBuffer.wrap(packet))
                    continue
                }

                val dnsReply = replyPacket.data.copyOf(replyPacket.length)
                Log.i("CSVpn", "runTunnelLoop: basic reply len=${dnsReply.size} for qname=$domain")
                val rebuilt = rebuildDnsReply(packet, dnsReply)
                output.write(ByteBuffer.wrap(rebuilt))
            } catch (e: Exception) {
                Log.e("CSVpn", "runTunnelLoop: DNS error: ${e.message}", e)
                try {
                    output.write(ByteBuffer.wrap(packet))
                } catch (_: Exception) {
                }
            }
        }

        try {
            dnsSocket.close()
            Log.i("CSVpn", "runTunnelLoop: DNS socket closed")
        } catch (_: Exception) {
        }
    }

    override fun onRevoke() {
        Log.i("CSVpn", "onRevoke called")
        stopTunnel()
        super.onRevoke()
    }

    override fun onDestroy() {
        Log.i("CSVpn", "onDestroy called")
        stopTunnel()
        super.onDestroy()
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
        val match = dstIp == fakeInt && dstPort == 53
        if (match) {
            Log.i("CSVpn", "isDnsToFakeServer: packet to fakeDnsIp=$fakeDnsIp:53")
        }
        return match
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
        var t = labels.joinToString(".").trim().lowercase()
        if (t.endsWith(".")) t = t.dropLast(1)
        if (t.startsWith("www.")) t = t.substring(4)
        return t
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
}
