package com.colourswift.cssecurity.vpn.wireguard

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Intent
import android.net.VpnService
import android.os.Build
import android.util.Log
import androidx.core.app.NotificationCompat
import com.colourswift.cssecurity.R
import com.wireguard.android.backend.GoBackend
import com.wireguard.android.backend.Tunnel
import com.wireguard.config.Config
import java.util.concurrent.Executors

class CSWireGuardService : VpnService() {

    companion object {
        @Volatile var isRunning: Boolean = false
        const val ACTION_START = "com.colourswift.cssecurity.WG_START"
        const val ACTION_STOP = "com.colourswift.cssecurity.WG_STOP"
        const val EXTRA_WG_CONFIG = "wg_config"
        private const val NOTIF_ID = 230
        private const val NOTIF_CHANNEL = "cs_wg_status"
    }

    private var backend: GoBackend? = null

    private val tunnel = object : Tunnel {
        override fun getName(): String = "cs_wg"
        override fun onStateChange(newState: Tunnel.State) {}
    }

    private val worker = Executors.newSingleThreadExecutor()
    @Volatile private var starting = false
    @Volatile private var up = false

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val i = intent ?: return START_NOT_STICKY
        val action = i.action ?: ""

        if (action == ACTION_STOP) {
            worker.execute {
                stopWireGuard()
                stopSelf()
            }
            return START_NOT_STICKY
        }

        if (action == ACTION_START) {
            val raw = i.getStringExtra(EXTRA_WG_CONFIG) ?: ""
            if (raw.isBlank()) {
                Log.e("CSWG", "Missing WireGuard config")
                isRunning = false
                stopSelf()
                return START_NOT_STICKY
            }

            worker.execute {
                if (starting) {
                    updateNotif("Connecting")
                    return@execute
                }

                starting = true
                startForegroundCompat("Connecting")

                try {
                    stopWireGuard()
                } catch (_: Throwable) {
                }

                isRunning = true
                startWireGuard(raw)
            }

            return START_STICKY
        }

        return START_STICKY
    }

    private fun startForegroundCompat(status: String) {
        val mgr = getSystemService(NotificationManager::class.java)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val ch = NotificationChannel(
                NOTIF_CHANNEL,
                "Secure VPN",
                NotificationManager.IMPORTANCE_LOW
            )
            ch.setShowBadge(false)
            mgr.createNotificationChannel(ch)
        }

        val n = NotificationCompat.Builder(this, NOTIF_CHANNEL)
            .setContentTitle("Secure VPN")
            .setContentText(status)
            .setSmallIcon(R.drawable.ic_notification)
            .setOngoing(true)
            .build()

        startForeground(NOTIF_ID, n)
    }

    private fun updateNotif(status: String) {
        try {
            val mgr = getSystemService(NotificationManager::class.java)
            val n = NotificationCompat.Builder(this, NOTIF_CHANNEL)
                .setContentTitle("Secure VPN")
                .setContentText(status)
                .setSmallIcon(R.drawable.ic_notification)
                .setOngoing(true)
                .build()
            mgr.notify(NOTIF_ID, n)
        } catch (_: Throwable) {
        }
    }

    private fun ensureBackend(): GoBackend {
        val b = backend
        if (b != null) return b
        val nb = GoBackend(this)
        backend = nb
        return nb
    }

    private fun startWireGuard(configText: String) {
        try {
            val cfg = Config.parse(configText.byteInputStream())
            ensureBackend().setState(tunnel, Tunnel.State.UP, cfg)
            up = true
            updateNotif("Connected")
        } catch (t: Throwable) {
            Log.e("CSWG", "Failed to start WG", t)
            updateNotif("Failed to connect")
            up = false
            stopWireGuard()
            stopSelf()
        } finally {
            starting = false
        }
    }

    private fun stopWireGuard() {
        try {
            backend?.setState(tunnel, Tunnel.State.DOWN, null)
        } catch (_: Throwable) {
        }

        try {
            stopForeground(true)
        } catch (_: Throwable) {
        }

        up = false
        starting = false
        isRunning = false
    }

    override fun onRevoke() {
        worker.execute { stopWireGuard() }
        super.onRevoke()
    }

    override fun onDestroy() {
        worker.execute { stopWireGuard() }
        worker.shutdownNow()
        isRunning = false
        super.onDestroy()
    }
}
