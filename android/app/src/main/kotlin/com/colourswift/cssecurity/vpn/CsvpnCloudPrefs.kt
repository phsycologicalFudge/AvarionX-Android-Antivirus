package com.colourswift.cssecurity.vpn

import android.content.Context
import android.util.Base64
import android.util.Log
import org.json.JSONObject

object CsvpnCloudPrefs {

    private const val PREFS = "cs_dns_cloud"
    private const val PREF_CLOUD_ENABLED_LISTS = "enabled_lists_json"
    private const val PREF_CLOUD_RESOLVER = "resolver"
    private const val PREF_CLOUD_PLAN = "plan"
    private const val PREF_CLOUD_URL = "cloud_url"
    private const val PREF_CLIENT_ID = "client_id"

    private const val DEFAULT_CLOUD_URL = "https://dns.colourswift.com/resolve"

    private fun prefs(ctx: Context): android.content.SharedPreferences {
        return ctx.applicationContext.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
    }

    fun cloudUrl(ctx: Context): String {
        val v = prefs(ctx).getString(PREF_CLOUD_URL, null)
        val s = v?.trim().orEmpty()
        val url = if (s.isNotEmpty()) s else DEFAULT_CLOUD_URL
        Log.i("CSVpn", "cloudUrl() -> $url")
        return url
    }

    fun cloudPlan(ctx: Context): String {
        val v = prefs(ctx).getString(PREF_CLOUD_PLAN, null)
        val s = v?.trim()?.lowercase().orEmpty()
        val plan = if (s == "pro") "pro" else "free"
        Log.i("CSVpn", "cloudPlan() -> $plan (raw=$v)")
        return plan
    }

    fun cloudClientId(ctx: Context): String? {
        val v = prefs(ctx).getString(PREF_CLIENT_ID, null)
        val s = v?.trim().orEmpty()
        val id = if (s.isNotEmpty()) s else null
        Log.i("CSVpn", "cloudClientId() -> $id")
        return id
    }

    fun cloudResolverIp(ctx: Context): String {
        val v = prefs(ctx).getString(PREF_CLOUD_RESOLVER, null)
        val s = v?.trim().orEmpty()
        val ip = if (s.isNotEmpty()) s else "1.1.1.1"
        Log.i("CSVpn", "cloudResolverIp() -> $ip")
        return ip
    }

    fun cloudSettingsB64(ctx: Context): String? {
        val listsJson = prefs(ctx).getString(PREF_CLOUD_ENABLED_LISTS, null)
        val resolver = prefs(ctx).getString(PREF_CLOUD_RESOLVER, null)

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
}
