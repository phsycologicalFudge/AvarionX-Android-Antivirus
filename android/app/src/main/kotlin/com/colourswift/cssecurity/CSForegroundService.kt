package com.colourswift.cssecurity

import android.app.*
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.ServiceConnection
import android.os.Build
import android.os.FileObserver
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.util.Log
import com.colourswift.cssecurity.rtp.SystemWatcher
import com.colourswift.cssecurity.rtp.SystemWatcherUserService
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import rikka.shizuku.Shizuku
import java.io.File

class CSForegroundService : Service() {

    companion object {
        @Volatile
        private var instance: CSForegroundService? = null

        fun releaseMode(mode: String): Boolean {
            val service = instance ?: return false
            service.handler.post {
                if (mode == "upload") {
                    service.releaseUpload()
                } else {
                    service.deactivateRtp()
                }
            }
            return true
        }
    }

    private var observer: FileObserver? = null
    private val downloadsPath = "/storage/emulated/0/Download"

    private val channelId = "cssecurity_realtime_v2"
    private val groupKey = "cssecurity_protection_group"
    private val notifRtpId = 1
    private val notifSummaryId = 2

    private val handler = Handler(Looper.getMainLooper())
    private var shizukuRetryCount = 0
    private val maxShizukuRetries = 10

    private var flutterEngine: FlutterEngine? = null
    private var realtimeEvents: EventChannel.EventSink? = null
    private val pendingPaths = mutableListOf<String>()
    private val recentPaths = LinkedHashMap<String, Long>(16, 0.75f, true)
    private val dedupeWindowMs = 2_000L

    private val foregroundChannelName = "colourswift/foreground_service"
    private val realtimeChannelName = "colourswift/realtime_stream"

    private val maxBufferedPaths = 64
    private val maxRecentPaths = 256

    private var packageReceiver: BroadcastReceiver? = null
    private var rtpActive = false
    private var uploadLeases = 0
    private var rtpInitialized = false
    private val statePrefs by lazy {
        getSharedPreferences("cs_foreground_state", Context.MODE_PRIVATE)
    }

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
        Log.i("CSRealtime", "Shizuku binder received - binding watcher service")
        handler.post { bindWatcherService() }
    }

    private val shizukuBinderDeadListener = Shizuku.OnBinderDeadListener {
        Log.i("CSRealtime", "Shizuku binder died - stopping SystemWatcher")
        SystemWatcher.stop()
        shizukuRetryCount = 0
    }

    override fun onCreate() {
        super.onCreate()
        instance = this
        Log.i("CSRealtime", "Service created")
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent == null) {
            if (statePrefs.getBoolean("rtp_active", false)) {
                activateRtp("AvarionX", "Protection active")
                return START_STICKY
            }
            stopSelf()
            return START_NOT_STICKY
        }

        val mode = intent.getStringExtra("mode") ?: "rtp"
        val operation = intent.getStringExtra("operation") ?: "start"
        val title = intent.getStringExtra("title") ?: "AvarionX Antivirus"
        val text = intent.getStringExtra("text") ?: "Realtime protection active"

        when (mode) {
            "upload" -> {
                if (operation == "stop") {
                    releaseUpload()
                } else {
                    acquireUpload(title, text)
                }
            }

            else -> {
                if (operation == "stop") {
                    deactivateRtp()
                } else {
                    activateRtp(title, text)
                }
            }
        }

        return if (rtpActive) START_STICKY else START_NOT_STICKY
    }

    private fun activateRtp(title: String, text: String) {
        rtpActive = true
        statePrefs.edit().putBoolean("rtp_active", true).apply()
        createNotification(title, text)

        if (!rtpInitialized) {
            rtpInitialized = true
            startBackgroundDart()
            startDownloadWatcher()
            startPackageReceiver()

            val prefs = getSharedPreferences(
                "FlutterSharedPreferences",
                Context.MODE_PRIVATE
            )

            val shizukuEnabled =
                prefs.getBoolean("flutter.shizuku_enabled", false)

            if (shizukuEnabled) {
                setupShizukuListeners()
                tryBindWatcherService()
                Log.i("CSRealtime", "Shizuku watcher enabled")
            } else {
                SystemWatcher.stop()
                Log.i("CSRealtime", "Shizuku watcher disabled by pref")
            }
        }

        Log.i("CSRealtime", "RTP foreground mode active")
    }

    private fun deactivateRtp() {
        rtpActive = false
        statePrefs.edit().putBoolean("rtp_active", false).apply()
        stopRtpComponents()

        if (uploadLeases > 0) {
            createNotification("AvarionX", "Uploading malicious APK(s)")
        } else {
            stopSelf()
        }

        Log.i("CSRealtime", "RTP foreground mode released")
    }

    private fun acquireUpload(title: String, text: String) {
        uploadLeases++
        if (!rtpActive) {
            createNotification(title, text)
        }
        Log.i("CSRealtime", "Upload foreground lease acquired count=$uploadLeases")
    }

    private fun releaseUpload() {
        if (uploadLeases > 0) uploadLeases--

        if (!rtpActive && uploadLeases == 0) {
            stopSelf()
        }

        Log.i("CSRealtime", "Upload foreground lease released count=$uploadLeases")
    }

    private fun stopRtpComponents() {
        observer?.stopWatching()
        observer = null

        packageReceiver?.let {
            try {
                unregisterReceiver(it)
            } catch (_: Throwable) {}
            packageReceiver = null
        }

        try {
            Shizuku.removeBinderReceivedListener(shizukuBinderReceivedListener)
            Shizuku.removeBinderDeadListener(shizukuBinderDeadListener)
        } catch (_: Throwable) {}

        try {
            unbindService(watcherServiceConnection)
        } catch (_: Throwable) {}

        SystemWatcher.stop()

        try {
            flutterEngine?.destroy()
        } catch (_: Throwable) {}

        flutterEngine = null
        realtimeEvents = null
        pendingPaths.clear()
        recentPaths.clear()
        rtpInitialized = false
    }

    override fun onDestroy() {
        stopRtpComponents()

        try {
            val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            manager.cancel(notifSummaryId)
        } catch (_: Throwable) {}

        handler.removeCallbacksAndMessages(null)
        uploadLeases = 0
        if (instance === this) instance = null
        Log.i("CSRealtime", "Service destroyed")
        super.onDestroy()
    }

    override fun onTaskRemoved(rootIntent: Intent?) {
        super.onTaskRemoved(rootIntent)
        Log.i("CSRealtime", "Task removed, relying on START_STICKY for restart")
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun startBackgroundDart() {
        if (flutterEngine != null) return

        try {
            val loader = FlutterInjector.instance().flutterLoader()
            loader.startInitialization(applicationContext)
            loader.ensureInitializationComplete(applicationContext, null)

            val engine = FlutterEngine(applicationContext)

            GeneratedPluginRegistrant.registerWith(engine)

            registerBackgroundChannels(engine)

            val entrypoint = DartExecutor.DartEntrypoint(
                loader.findAppBundlePath(),
                "rtpBackgroundMain"
            )

            engine.dartExecutor.executeDartEntrypoint(entrypoint)
            flutterEngine = engine

            Log.i("CSRealtime", "Background Dart engine started")
        } catch (e: Throwable) {
            Log.e("CSRealtime", "Failed to start background Dart: ${e.message}")
        }
    }

    private fun setupShizukuListeners() {
        Shizuku.addBinderReceivedListenerSticky(shizukuBinderReceivedListener)
        Shizuku.addBinderDeadListener(shizukuBinderDeadListener)
    }

    private fun registerBackgroundChannels(engine: FlutterEngine) {
        MethodChannel(engine.dartExecutor.binaryMessenger, foregroundChannelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "startService" -> {
                        val args = call.arguments as? Map<*, *>
                        val title = args?.get("title") as? String ?: "AvarionX"
                        val text = args?.get("text") as? String ?: "Realtime protection active"
                        val mode = args?.get("mode") as? String ?: "rtp"

                        if (mode == "upload") {
                            acquireUpload(title, text)
                        } else {
                            activateRtp(title, text)
                        }

                        result.success(true)
                    }

                    "stopService" -> {
                        val args = call.arguments as? Map<*, *>
                        val mode = args?.get("mode") as? String ?: "rtp"

                        if (mode == "upload") {
                            releaseUpload()
                        } else {
                            deactivateRtp()
                        }

                        result.success(true)
                    }

                    "showNotification" -> {
                        val args = call.arguments as? Map<*, *>
                        val title = args?.get("title") as? String ?: "AvarionX"
                        val text = args?.get("text") as? String ?: ""
                        val openQuarantine = args?.get("openQuarantine") as? Boolean ?: false

                        val autoDismissAfterSeconds = when (val v = args?.get("autoDismissAfterSeconds")) {
                            is Int -> v
                            is Long -> v.toInt()
                            is Double -> v.toInt()
                            else -> null
                        }

                        showUserNotification(
                            title,
                            text,
                            openQuarantine,
                            autoDismissAfterSeconds
                        )

                        result.success(true)
                    }

                    "toast" -> {
                        val args = call.arguments as? Map<*, *>
                        val text = args?.get("text") as? String ?: ""

                        if (text.isNotBlank()) {
                            Handler(Looper.getMainLooper()).post {
                                android.widget.Toast.makeText(
                                    applicationContext,
                                    text,
                                    android.widget.Toast.LENGTH_SHORT
                                ).show()
                            }
                        }

                        result.success(true)
                    }

                    else -> result.notImplemented()
                }
            }

        EventChannel(engine.dartExecutor.binaryMessenger, realtimeChannelName)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    realtimeEvents = events
                    Log.i("CSRealtime", "Background realtime stream attached")
                    if (events != null && pendingPaths.isNotEmpty()) {
                        Log.i("CSRealtime", "Draining ${pendingPaths.size} buffered path(s)")
                        pendingPaths.forEach { events.success(it) }
                        pendingPaths.clear()
                    }
                }

                override fun onCancel(arguments: Any?) {
                    realtimeEvents = null
                    Log.i("CSRealtime", "Background realtime stream detached")
                }
            })
    }

    private fun tryBindWatcherService() {
        if (!Shizuku.pingBinder()) {
            Log.i("CSRealtime", "Shizuku not ready yet - waiting for binder")
            return
        }
        bindWatcherService()
    }

    private fun bindWatcherService() {
        if (SystemWatcher.isRunning()) {
            Log.i("CSRealtime", "SystemWatcher already running - skipping bind")
            return
        }

        try {
            if (!Shizuku.pingBinder()) {
                scheduleRetry()
                return
            }

            if (Shizuku.checkSelfPermission() != android.content.pm.PackageManager.PERMISSION_GRANTED) {
                Log.w("CSRealtime", "Shizuku permission not granted - cannot start SystemWatcher")
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
            Log.w("CSRealtime", "Max Shizuku retries reached - giving up")
            return
        }
        shizukuRetryCount++
        val delayMs = (shizukuRetryCount * 3000L).coerceAtMost(30_000L)
        Log.i("CSRealtime", "Retrying Shizuku bind in ${delayMs}ms (attempt $shizukuRetryCount)")
        handler.postDelayed({ bindWatcherService() }, delayMs)
    }

    private fun notificationBuilder(channel: String): Notification.Builder {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(applicationContext, channel)
        } else {
            Notification.Builder(applicationContext)
        }
    }

    private fun createNotification(title: String, text: String) {
        val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                channelId,
                "AvarionX background activity",
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

        if (rtpActive) {
            val summary = notificationBuilder(channelId)
                .setContentTitle("AvarionX")
                .setContentText("Protection active")
                .setSmallIcon(R.drawable.ic_notification)
                .setGroup(groupKey)
                .setGroupSummary(true)
                .setOnlyAlertOnce(true)
                .build()

            manager.notify(notifSummaryId, summary)
        } else {
            manager.cancel(notifSummaryId)
        }

        val notification = notificationBuilder(channelId)
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

    private fun showUserNotification(
        title: String,
        text: String,
        openQuarantine: Boolean,
        autoDismissAfterSeconds: Int? = null
    ) {
        val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val channel = "cssecurity_user_alerts"

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val notificationChannel = NotificationChannel(
                channel,
                "Security Alerts",
                NotificationManager.IMPORTANCE_HIGH
            )
            manager.createNotificationChannel(notificationChannel)
        }

        val intent = Intent(applicationContext, MainActivity::class.java).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_CLEAR_TOP)

            if (openQuarantine) {
                putExtra("open_quarantine", true)
            }
        }

        val pendingIntent = PendingIntent.getActivity(
            applicationContext,
            System.currentTimeMillis().toInt(),
            intent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )

        val notification = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(applicationContext, channel)
        } else {
            Notification.Builder(applicationContext)
        }
            .setContentTitle(title)
            .setContentText(text)
            .setSmallIcon(R.drawable.ic_notification)
            .setContentIntent(pendingIntent)
            .setAutoCancel(true)
            .build()

        val id = System.currentTimeMillis().toInt()
        manager.notify(id, notification)

        if (autoDismissAfterSeconds != null && autoDismissAfterSeconds > 0) {
            Handler(Looper.getMainLooper()).postDelayed({
                try {
                    manager.cancel(id)
                } catch (_: Exception) {}
            }, autoDismissAfterSeconds * 1000L)
        }
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

                    handler.post {
                        val now = System.currentTimeMillis()
                        val last = recentPaths[fullPath]
                        if (last != null && now - last < dedupeWindowMs) {
                            Log.i("CSRealtime", "Deduped file event: $fullPath")
                            return@post
                        }

                        recentPaths[fullPath] = now
                        while (recentPaths.size > maxRecentPaths) {
                            val firstKey = recentPaths.entries.firstOrNull()?.key ?: break
                            recentPaths.remove(firstKey)
                        }

                        val sink = realtimeEvents
                        if (sink != null) {
                            Log.i("CSRealtime", "Sending file to background Dart: $fullPath")
                            sink.success(fullPath)
                        } else {
                            Log.w("CSRealtime", "Background Dart stream not attached, buffering: $fullPath")

                            if (pendingPaths.size >= maxBufferedPaths) {
                                pendingPaths.removeAt(0)
                            }

                            pendingPaths.add(fullPath)
                        }
                    }
                }
            }
        }
        observer?.startWatching()
        Log.i("CSRealtime", "FileObserver active on $downloadsPath")
    }

    private fun startPackageReceiver() {
        val receiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                val action = intent?.action ?: return
                if (action != Intent.ACTION_PACKAGE_ADDED && action != Intent.ACTION_PACKAGE_REPLACED) return

                val uri = intent.data ?: return
                val pkg = uri.schemeSpecificPart ?: return
                if (pkg.isBlank()) return

                if (action == Intent.ACTION_PACKAGE_ADDED) {
                    val replacing = intent.getBooleanExtra(Intent.EXTRA_REPLACING, false)
                    if (replacing) return
                }

                handler.post {
                    try {
                        val pm = applicationContext.packageManager
                        val info = pm.getApplicationInfo(pkg, 0)
                        val apkPath = info.sourceDir
                        if (apkPath.isNullOrBlank()) return@post

                        val eventKey = "app::$pkg"
                        val now = System.currentTimeMillis()
                        val last = recentPaths[eventKey]
                        if (last != null && now - last < dedupeWindowMs) {
                            Log.i("CSRealtime", "Deduped package event: $pkg")
                            return@post
                        }

                        recentPaths[eventKey] = now
                        while (recentPaths.size > maxRecentPaths) {
                            val firstKey = recentPaths.entries.firstOrNull()?.key ?: break
                            recentPaths.remove(firstKey)
                        }

                        val payload = "app::$pkg::$apkPath"
                        Log.i("CSRealtime", "Package event queued: $payload")

                        val sink = realtimeEvents
                        if (sink != null) {
                            sink.success(payload)
                        } else {
                            if (pendingPaths.size >= maxBufferedPaths) {
                                pendingPaths.removeAt(0)
                            }
                            pendingPaths.add(payload)
                        }
                    } catch (e: Throwable) {
                        Log.w("CSRealtime", "Package event resolution failed for $pkg: ${e.message}")
                    }
                }
            }
        }

        val filter = IntentFilter().apply {
            addAction(Intent.ACTION_PACKAGE_ADDED)
            addAction(Intent.ACTION_PACKAGE_REPLACED)
            addDataScheme("package")
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(receiver, filter, RECEIVER_NOT_EXPORTED)
        } else {
            registerReceiver(receiver, filter)
        }

        packageReceiver = receiver
        Log.i("CSRealtime", "Package install receiver registered")
    }
}