package com.colourswift.cssecurity

import android.content.Context
import android.content.pm.PackageManager
import android.net.ConnectivityManager
import android.net.NetworkCapabilities

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

    fun isWifi(ctx: Context): Boolean {
        val cm = ctx.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        val n = cm.activeNetwork ?: return false
        val caps = cm.getNetworkCapabilities(n) ?: return false
        return caps.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)
    }

    fun applyToBuilderIfWifi(ctx: Context, builder: android.net.VpnService.Builder) {
        if (!isWifi(ctx)) return
        val pkgs = getWifiBlockedPkgs(ctx)
        if (pkgs.isEmpty()) return
        val pm = ctx.packageManager
        for (pkg in pkgs) {
            try {
                pm.getApplicationInfo(pkg, 0)
                builder.addDisallowedApplication(pkg)
            } catch (_: PackageManager.NameNotFoundException) {
            } catch (_: Exception) {
            }
        }
    }
}
