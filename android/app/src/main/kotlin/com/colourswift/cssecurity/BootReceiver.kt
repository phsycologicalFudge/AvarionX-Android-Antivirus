package com.colourswift.cssecurity

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Handler
import android.os.Looper

class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != Intent.ACTION_BOOT_COMPLETED) return

        val prefs = context.getSharedPreferences(
            "FlutterSharedPreferences",
            Context.MODE_PRIVATE
        )

        val protectionEnabled = prefs.getBoolean(
            "flutter.protectionEnabled",
            false
        )

        if (!protectionEnabled) return

        Handler(Looper.getMainLooper()).postDelayed({
            try {
                val realtime = Intent(context, CSForegroundService::class.java)
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    context.startForegroundService(realtime)
                } else {
                    context.startService(realtime)
                }
            } catch (_: Exception) {
            }
        }, 7000)
    }
}