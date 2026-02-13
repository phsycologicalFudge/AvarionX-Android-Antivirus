package com.colourswift.cssecurity.vpn

import android.content.Context

object CsvpnUsage {

    private const val PREFS = "cs_dns_cloud"

    private fun prefs(ctx: Context): android.content.SharedPreferences {
        return ctx.applicationContext.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
    }

    private fun resetAtMsUtc(): Long {
        val now = java.util.Calendar.getInstance(java.util.TimeZone.getTimeZone("UTC"))
        now.set(java.util.Calendar.HOUR_OF_DAY, 0)
        now.set(java.util.Calendar.MINUTE, 0)
        now.set(java.util.Calendar.SECOND, 0)
        now.set(java.util.Calendar.MILLISECOND, 0)
        return now.timeInMillis + 24L * 60L * 60L * 1000L
    }

    fun ensureUsageWindowAndLimit(ctx: Context) {
        val p = prefs(ctx)
        val plan = CsvpnCloudPrefs.cloudPlan(ctx)
        val now = System.currentTimeMillis()
        val reset = p.getLong("usage_reset_ms", 0L)
        if (reset <= now) {
            p.edit()
                .putLong("usage_used", 0L)
                .putLong("usage_reset_ms", resetAtMsUtc())
                .apply()
        }
        val limit = if (plan == "pro") 0L else 100000L
        p.edit().putLong("usage_limit", limit).apply()
    }

    fun bumpUsageCount(ctx: Context) {
        val p = prefs(ctx)
        p.edit().putLong("usage_used", p.getLong("usage_used", 0L) + 1L).apply()
    }

    fun bumpUsageCountDirect(ctx: Context) {
        val p = prefs(ctx)
        p.edit().putLong("usage_used", p.getLong("usage_used", 0L) + 1L).apply()
    }
}
