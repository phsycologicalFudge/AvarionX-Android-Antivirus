package com.colourswift.cssecurity.vpn.backend_port.network

import org.json.JSONArray
import org.json.JSONObject

object VpnConfigBuilder {

    private const val MTU = 1280

    fun str(json: JSONObject?, key: String): String {
        if (json == null || json.isNull(key)) return ""
        return json.optString(key, "").trim()
    }

    fun strList(json: JSONObject?, key: String): List<String> {
        if (json == null || json.isNull(key)) return emptyList()
        val arr: JSONArray = json.optJSONArray(key) ?: return emptyList()
        val out = ArrayList<String>(arr.length())
        for (i in 0 until arr.length()) {
            if (arr.isNull(i)) continue
            val v = arr.optString(i, "").trim()
            if (v.isNotEmpty()) out.add(v)
        }
        return out
    }

    fun buildWgConfig(
        privateKeyB64: String,
        address: String,
        serverPublicKeyB64: String,
        endpoint: String,
        allowedIps: List<String>,
        dns: List<String>
    ): String {
        val b = StringBuilder()
        b.appendLine("[Interface]")
        b.appendLine("PrivateKey = $privateKeyB64")
        b.appendLine("Address = ${fixCidr(address)}")
        b.appendLine("MTU = $MTU")
        if (dns.isNotEmpty()) {
            b.appendLine("DNS = ${dns.joinToString(", ")}")
        }

        b.appendLine("")
        b.appendLine("[Peer]")
        b.appendLine("PublicKey = $serverPublicKeyB64")
        b.appendLine("Endpoint = $endpoint")
        b.appendLine("AllowedIPs = ${allowedIps.joinToString(", ")}")
        b.appendLine("PersistentKeepalive = 25")
        return b.toString()
    }

    private fun fixCidr(address: String): String {
        val parts = address.split(",").map { it.trim() }.filter { it.isNotEmpty() }
        val out = ArrayList<String>(parts.size)
        for (p in parts) {
            when {
                p.contains("/") -> out.add(p)
                p.contains(":") -> out.add("$p/128")
                else -> out.add("$p/32")
            }
        }
        return out.joinToString(", ")
    }
}
