package com.colourswift.cssecurity

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log

class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action ?: return
        if (action != Intent.ACTION_BOOT_COMPLETED && action != Intent.ACTION_MY_PACKAGE_REPLACED) return

        val flutterPrefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val statePrefs = context.getSharedPreferences("cs_foreground_state", Context.MODE_PRIVATE)
        val enabled = flutterPrefs.getBoolean("flutter.protectionEnabled", false) ||
            statePrefs.getBoolean("rtp_active", false)
        if (!enabled) return

        val realtime = Intent(context, CSForegroundService::class.java)
            .putExtra("mode", "rtp")
            .putExtra("operation", "start")
            .putExtra("title", "AvarionX")
            .putExtra("text", "Protection active")

        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(realtime)
            } else {
                context.startService(realtime)
            }
            Log.i("CSRealtime", "RTP started from $action")
        } catch (e: Exception) {
            Log.e("CSRealtime", "RTP start from $action failed: ${e.javaClass.simpleName} ${e.message}")
        }
    }
}
