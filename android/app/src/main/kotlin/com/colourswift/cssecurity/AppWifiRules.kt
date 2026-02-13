package com.colourswift.cssecurity

import android.content.Context
import android.content.pm.PackageManager
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import com.colourswift.cssecurity.vpn.CSVpnService

object AppWifiRules {
    private const val PREFS = "cs_app_rules"
    private const val KEY = "wifi_blocked_pkgs"

    fun getWifiBlockedPkgs(ctx: Context): Set<String> {
        val prefs = ctx.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
        return prefs.getStringSet(KEY, emptySet()) ?: emptySet()
    }

    fun setWifiBlocked(ctx: Context, pkg: String, blocked: Boolean): Boolean {
        val p = pkg.trim()
        if (p.isEmpty()) return false
        val prefs = ctx.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
        val cur = prefs.getStringSet(KEY, emptySet()) ?: emptySet()
        val next = HashSet(cur)
        if (blocked) next.add(p) else next.remove(p)
        return prefs.edit().putStringSet(KEY, next).commit()
    }

    fun applyToBuilderIfWifiAndLockdown(ctx: Context, builder: android.net.VpnService.Builder) {
        if (!isWifi(ctx)) return

        val state = try {
            CSVpnService.snapshotLockdownState(ctx)
        } catch (_: Exception) {
            mapOf("always_on" to false, "lockdown" to false)
        }

        val lockdown = (state["lockdown"] as? Boolean) == true
        if (!lockdown) return

        val blocked = getWifiBlockedPkgs(ctx)
        if (blocked.isEmpty()) return

        for (pkg in blocked) {
            try {
                builder.addDisallowedApplication(pkg)
            } catch (_: Exception) {}
        }
    }

    fun isWifi(ctx: Context): Boolean {
        val cm = ctx.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        val n = cm.activeNetwork ?: return false
        val caps = cm.getNetworkCapabilities(n) ?: return false
        return caps.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)
    }

    fun shouldBlockUidOnWifi(ctx: Context, uid: Int): Boolean {
        if (!isWifi(ctx)) return false
        val blocked = getWifiBlockedPkgs(ctx)
        if (blocked.isEmpty()) return false

        val pkgs = try {
            ctx.packageManager.getPackagesForUid(uid)?.toList().orEmpty()
        } catch (_: Exception) {
            emptyList()
        }

        if (pkgs.isEmpty()) return false
        for (p in pkgs) {
            if (blocked.contains(p)) return true
        }
        return false
    }
}
