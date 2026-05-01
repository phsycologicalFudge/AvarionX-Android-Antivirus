package com.colourswift.cssecurity

import android.app.*
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import android.os.Build
import android.os.FileObserver
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.util.Log
import com.colourswift.cssecurity.rtp.SystemWatcher
import com.colourswift.cssecurity.rtp.SystemWatcherUserService
import rikka.shizuku.Shizuku
import java.io.File

class CSForegroundService : Service() {

    private var observer: FileObserver? = null
    private val downloadsPath = "/storage/emulated/0/Download"

    private val channelId = "cssecurity_realtime_v2"
    private val groupKey = "cssecurity_protection_group"
    private val notifRtpId = 1
    private val notifSummaryId = 2

    private val handler = Handler(Looper.getMainLooper())
    private var shizukuRetryCount = 0
    private val maxShizukuRetries = 10

    private val watcherServiceConnection = object : ServiceConnection {
        override fun onServiceConnected(name: ComponentName?, binder: IBinder?) {
            Log.i("CSRealtime", "SystemWatcher user service connected")
            shizukuRetryCount = 0
            try {
                val svc = ISystemWatcherService.Stub.asInterface(binder)
                SystemWatcher.start(this@CSForegroundService, svc)
                Log.i("CSRealtime", "SystemWatcher started from boot service")
            } catch (e: Throwable) {
                Log.e("CSRealtime", "Failed to start SystemWatcher: ${e.message}")
            }
        }

        override fun onServiceDisconnected(name: ComponentName?) {
            Log.i("CSRealtime", "SystemWatcher user service disconnected")
            SystemWatcher.stop()
        }
    }

    private val shizukuBinderReceivedListener = Shizuku.OnBinderReceivedListener {
        Log.i("CSRealtime", "Shizuku binder received — binding watcher service")
        handler.post { bindWatcherService() }
    }

    private val shizukuBinderDeadListener = Shizuku.OnBinderDeadListener {
        Log.i("CSRealtime", "Shizuku binder died — stopping SystemWatcher")
        SystemWatcher.stop()
        shizukuRetryCount = 0
    }

    override fun onCreate() {
        super.onCreate()
        startDownloadWatcher()
        setupShizukuListeners()
        tryBindWatcherService()
        Log.i("CSRealtime", "Service created")
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val title = intent?.getStringExtra("title") ?: "AvarionX Antivirus"
        val text = intent?.getStringExtra("text") ?: "Realtime protection active"
        createNotification(title, text)
        return START_STICKY
    }

    override fun onDestroy() {
        observer?.stopWatching()
        observer = null

        try {
            Shizuku.removeBinderReceivedListener(shizukuBinderReceivedListener)
            Shizuku.removeBinderDeadListener(shizukuBinderDeadListener)
        } catch (_: Throwable) {}

        try {
            unbindService(watcherServiceConnection)
        } catch (_: Throwable) {}

        SystemWatcher.stop()

        try {
            val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            manager.cancel(notifSummaryId)
        } catch (_: Throwable) {}

        handler.removeCallbacksAndMessages(null)
        Log.i("CSRealtime", "Service destroyed")
        super.onDestroy()
    }

    override fun onTaskRemoved(rootIntent: Intent?) {
        super.onTaskRemoved(rootIntent)
        Log.i("CSRealtime", "Task removed, relying on START_STICKY for restart")
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun setupShizukuListeners() {
        Shizuku.addBinderReceivedListenerSticky(shizukuBinderReceivedListener)
        Shizuku.addBinderDeadListener(shizukuBinderDeadListener)
    }

    private fun tryBindWatcherService() {
        if (!Shizuku.pingBinder()) {
            Log.i("CSRealtime", "Shizuku not ready yet — waiting for binder")
            return
        }
        bindWatcherService()
    }

    private fun bindWatcherService() {
        if (SystemWatcher.isRunning()) {
            Log.i("CSRealtime", "SystemWatcher already running — skipping bind")
            return
        }

        try {
            if (!Shizuku.pingBinder()) {
                scheduleRetry()
                return
            }

            if (Shizuku.checkSelfPermission() != android.content.pm.PackageManager.PERMISSION_GRANTED) {
                Log.w("CSRealtime", "Shizuku permission not granted — cannot start SystemWatcher")
                return
            }

            val args = Shizuku.UserServiceArgs(
                ComponentName(packageName, SystemWatcherUserService::class.java.name)
            ).daemon(false).processNameSuffix("watcher").debuggable(false).version(1)

            Shizuku.bindUserService(args, watcherServiceConnection)
            Log.i("CSRealtime", "Binding SystemWatcher user service")
        } catch (e: Throwable) {
            Log.e("CSRealtime", "bindWatcherService failed: ${e.message}")
            scheduleRetry()
        }
    }

    private fun scheduleRetry() {
        if (shizukuRetryCount >= maxShizukuRetries) {
            Log.w("CSRealtime", "Max Shizuku retries reached — giving up")
            return
        }
        shizukuRetryCount++
        val delayMs = (shizukuRetryCount * 3000L).coerceAtMost(30_000L)
        Log.i("CSRealtime", "Retrying Shizuku bind in ${delayMs}ms (attempt $shizukuRetryCount)")
        handler.postDelayed({ bindWatcherService() }, delayMs)
    }

    private fun createNotification(title: String, text: String) {
        val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                channelId,
                "Realtime Protection",
                NotificationManager.IMPORTANCE_LOW
            )
            channel.setShowBadge(false)
            manager.createNotificationChannel(channel)
        }

        val notificationIntent = Intent(applicationContext, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(
            applicationContext,
            0,
            notificationIntent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )

        val summary = Notification.Builder(applicationContext, channelId)
            .setContentTitle("AVarionX")
            .setContentText("Protection active")
            .setSmallIcon(R.drawable.ic_notification)
            .setGroup(groupKey)
            .setGroupSummary(true)
            .setOnlyAlertOnce(true)
            .build()

        manager.notify(notifSummaryId, summary)

        val notification = Notification.Builder(applicationContext, channelId)
            .setContentTitle(title)
            .setContentText(text)
            .setSmallIcon(R.drawable.ic_notification)
            .setContentIntent(pendingIntent)
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .setGroup(groupKey)
            .build()

        startForeground(notifRtpId, notification)
    }

    private fun startDownloadWatcher() {
        val path = File(downloadsPath)
        if (!path.exists()) path.mkdirs()

        observer?.stopWatching()
        observer = object : FileObserver(path.absolutePath, CREATE or MOVED_TO) {
            override fun onEvent(event: Int, fileName: String?) {
                fileName?.let {
                    val fullPath = "$downloadsPath/$it"
                    Log.i("CSRealtime", "Detected new file: $fullPath")

                    val intent = Intent("com.colourswift.cssecurity.NEW_FILE_DETECTED")
                    intent.setPackage("com.colourswift.cssecurity")
                    intent.putExtra("path", fullPath)
                    sendBroadcast(intent)
                }
            }
        }
        observer?.startWatching()
        Log.i("CSRealtime", "FileObserver active on $downloadsPath")
    }
}