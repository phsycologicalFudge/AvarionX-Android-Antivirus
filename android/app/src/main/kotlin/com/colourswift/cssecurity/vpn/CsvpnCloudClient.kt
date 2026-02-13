package com.colourswift.cssecurity.vpn

import android.content.Context
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.util.Base64
import org.json.JSONObject
import java.net.HttpURLConnection
import java.net.URL

object CsvpnCloudClient {

    private fun openCloudHttp(ctx: Context, url: String): HttpURLConnection {
        val cm = ctx.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager

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

    fun cloudResolve(ctx: Context, dnsQuery: ByteArray, qname: String?): Pair<ByteArray?, Map<String, Any?>?> {
        val url = CsvpnCloudPrefs.cloudUrl(ctx)
        val plan = CsvpnCloudPrefs.cloudPlan(ctx)
        val clientId = CsvpnCloudPrefs.cloudClientId(ctx)
        val settingsB64 = CsvpnCloudPrefs.cloudSettingsB64(ctx)

        val bodyObj = JSONObject()
        bodyObj.put("dns_b64", Base64.encodeToString(dnsQuery, Base64.NO_WRAP))
        if (settingsB64 != null) bodyObj.put("settings_b64", settingsB64)
        val bodyBytes = bodyObj.toString().toByteArray(Charsets.UTF_8)

        val start = System.nanoTime()

        try {
            val conn = openCloudHttp(ctx, url)
            conn.requestMethod = "POST"
            conn.connectTimeout = 3000
            conn.readTimeout = 3500
            conn.doOutput = true
            conn.setRequestProperty("Content-Type", "application/json")
            conn.setRequestProperty("x-plan", plan)
            if (clientId != null) conn.setRequestProperty("x-client-id", clientId)

            conn.outputStream.use { it.write(bodyBytes) }

            val code = conn.responseCode
            val stream = if (code in 200..299) conn.inputStream else conn.errorStream
            val raw = stream?.readBytes() ?: ByteArray(0)
            if (raw.isEmpty()) return Pair(null, null)

            val respJson = JSONObject(String(raw, Charsets.UTF_8))
            val dnsB64 = respJson.optString("dns_b64", null) ?: return Pair(null, null)
            val meta = respJson.optJSONObject("meta")

            val dnsReply = Base64.decode(dnsB64, Base64.DEFAULT)

            CsvpnUsage.bumpUsageCountDirect(ctx)

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

            return Pair(dnsReply, metaMap)
        } catch (_: Exception) {
            val latencyMs = ((System.nanoTime() - start) / 1_000_000L).toInt()
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
}
