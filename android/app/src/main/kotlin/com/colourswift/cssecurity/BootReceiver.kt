package com.colourswift.cssecurity

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.util.Log

class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Intent.ACTION_BOOT_COMPLETED) {

            Handler(Looper.getMainLooper()).postDelayed({
                try {
                    val realtime = Intent(context, CSForegroundService::class.java)
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        context.startForegroundService(realtime)
                    } else {
                        context.startService(realtime)
                    }
                } catch (e: Exception) {
                }

                try {
                    val vpn = Intent(context, CSVpnService::class.java)
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        context.startForegroundService(vpn)
                    } else {
                        context.startService(vpn)
                    }
                } catch (e: Exception) {
                }
            }, 7000)
        }
    }
}

