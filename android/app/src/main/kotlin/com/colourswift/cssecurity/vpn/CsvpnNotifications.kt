package com.colourswift.cssecurity.vpn

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Intent
import android.content.pm.ServiceInfo
import android.os.Build
import android.util.Log
import androidx.core.app.ServiceCompat
import com.colourswift.cssecurity.MainActivity
import com.colourswift.cssecurity.R

object CsvpnNotifications {

    private const val PROTECTION_CHANNEL_ID = "cssecurity_realtime_v2"
    private const val GROUP_KEY = "cssecurity_protection_group"
    private const val SUMMARY_ID = 2

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
            Notification.Builder(CSVpnService.instanceContext, PROTECTION_CHANNEL_ID)
                .setContentTitle("AVarionX")
                .setContentText("Protection active")
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentIntent(pi)
                .setOnlyAlertOnce(true)
                .setGroup(GROUP_KEY)
                .setGroupSummary(true)
                .build()
        } else {
            Notification.Builder(CSVpnService.instanceContext)
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
        val title = "Cloud Protection Active"
        val text = "DNS Protection"
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(CSVpnService.instanceContext, PROTECTION_CHANNEL_ID)
                .setContentTitle(title)
                .setContentText(text)
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentIntent(pi)
                .setOngoing(true)
                .setOnlyAlertOnce(true)
                .setGroup(GROUP_KEY)
                .build()
        } else {
            Notification.Builder(CSVpnService.instanceContext)
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

    fun startForegroundNotif(service: CSVpnService) {
        CSVpnService.instanceContext = service.applicationContext
        val mgr = service.getSystemService(NotificationManager::class.java)
        ensureProtectionChannel(mgr)

        val pi = PendingIntent.getActivity(
            service,
            0,
            Intent(service, MainActivity::class.java),
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )

        mgr.notify(SUMMARY_ID, buildSummaryNotification(pi))
        val n = buildVpnNotification(pi)

        Log.i("CSVpn", "Starting foreground")
        ServiceCompat.startForeground(
            service,
            CSVpnService.NOTIF_ID,
            n,
            ServiceInfo.FOREGROUND_SERVICE_TYPE_SPECIAL_USE
        )
    }
}
