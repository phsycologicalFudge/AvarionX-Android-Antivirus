package com.colourswift.cssecurity

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.os.PowerManager
import android.provider.Settings
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.Executors
import com.colourswift.cssecurity.https.CertService
import com.colourswift.cssecurity.rtp.SystemWatcher
import com.colourswift.cssecurity.rtp.RealtimeReceiver
import com.colourswift.cssecurity.apkanalyser.ApkAnalyserBridge

class FastAppsPlugin(private val context: Context, messenger: BinaryMessenger) : MethodChannel.MethodCallHandler {
    private val channel = MethodChannel(messenger, "cs.fastapps")
    private val io = Executors.newSingleThreadExecutor()

    init {
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "listUserApps" -> {
                io.execute {
                    try {
                        val pm = context.packageManager
                        val apps = pm.getInstalledApplications(0)
                            .filter { (it.flags and ApplicationInfo.FLAG_SYSTEM) == 0 }
                            .map {
                                val label = pm.getApplicationLabel(it).toString()
                                mapOf(
                                    "name" to label,
                                    "package" to it.packageName,
                                    "path" to it.sourceDir
                                )
                            }
                            .sortedBy { (it["name"] as? String)?.lowercase() ?: "" }
                        Handler(Looper.getMainLooper()).post { result.success(apps) }
                    } catch (t: Throwable) {
                        Handler(Looper.getMainLooper()).post {
                            result.error("ERR", t.message, null)
                        }
                    }
                }
            }

            "getAppIconPng" -> {
                io.execute {
                    try {
                        val pkg = call.argument<String>("package") ?: ""
                        if (pkg.isBlank()) {
                            Handler(Looper.getMainLooper()).post { result.success(null) }
                            return@execute
                        }

                        val pm = context.packageManager
                        val drawable = pm.getApplicationIcon(pkg)

                        val bmp = if (drawable is android.graphics.drawable.BitmapDrawable) {
                            drawable.bitmap
                        } else {
                            val w = if (drawable.intrinsicWidth > 0) drawable.intrinsicWidth else 96
                            val h = if (drawable.intrinsicHeight > 0) drawable.intrinsicHeight else 96
                            val b = android.graphics.Bitmap.createBitmap(
                                w,
                                h,
                                android.graphics.Bitmap.Config.ARGB_8888
                            )
                            val c = android.graphics.Canvas(b)
                            drawable.setBounds(0, 0, c.width, c.height)
                            drawable.draw(c)
                            b
                        }

                        val baos = java.io.ByteArrayOutputStream()
                        bmp.compress(android.graphics.Bitmap.CompressFormat.PNG, 100, baos)
                        val bytes = baos.toByteArray()

                        Handler(Looper.getMainLooper()).post { result.success(bytes) }
                    } catch (_: Throwable) {
                        Handler(Looper.getMainLooper()).post { result.success(null) }
                    }
                }
            }

            else -> result.notImplemented()
        }
    }
}

class MainActivity : FlutterActivity() {
    private val CHANNEL = "colourswift/foreground_service"
    private val EVENT_CHANNEL = "colourswift/realtime_stream"
    private var receiver: RealtimeReceiver? = null

    private var heuristicEvents: EventChannel.EventSink? = null
    private var watcherStateEvents: EventChannel.EventSink? = null
    private var processEvents: EventChannel.EventSink? = null
    private var fe: FlutterEngine? = null
    private var pollEvents: EventChannel.EventSink? = null

    private val SCAN_NOTIF_ID = 201
    private val SCAN_NOTIF_CHANNEL = "cssecurity_scan_status"
    private val EXTRA_CANCEL_SCHEDULED_SCAN = "cancel_scheduled_scan"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            splashScreen.setOnExitAnimationListener { splashScreenView ->
                splashScreenView.remove()
            }
        }
        handleIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        handleIntent(intent)
    }

    private val ROUTING_CHANNEL = "colourswift/routing"

    private fun handleIntent(i: Intent?) {
        if (i == null) return

        if (i.getBooleanExtra("open_quarantine", false)) {
            fe?.let { engine ->
                MethodChannel(engine.dartExecutor.binaryMessenger, ROUTING_CHANNEL).invokeMethod("pushQuarantine", null)
                i.removeExtra("open_quarantine")
            }
        }

        val cancel = i.getBooleanExtra(EXTRA_CANCEL_SCHEDULED_SCAN, false)
        if (!cancel) return
        try {
            val engine = fe ?: return
            MethodChannel(engine.dartExecutor.binaryMessenger, CHANNEL).invokeMethod("cancelScheduledScan", null)
        } catch (_: Exception) {}
        try {
            i.removeExtra(EXTRA_CANCEL_SCHEDULED_SCAN)
        } catch (_: Exception) {}
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        fe = flutterEngine

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "startService" -> {
                        val args = call.arguments as? Map<*, *>
                        val title = args?.get("title") as? String ?: "AvarionX"
                        val text = args?.get("text") as? String ?: "Realtime protection active"
                        startForegroundServiceCompat(title, text)
                        result.success(true)
                    }

                    "stopService" -> {
                        stopForegroundService()
                        result.success(true)
                    }

                    "showNotification" -> {
                        val args = call.arguments as? Map<*, *>
                        val title = args?.get("title") as? String ?: "AvarionX"
                        val text = args?.get("text") as? String ?: ""
                        val autoDismissAfterSeconds = when (val v = args?.get("autoDismissAfterSeconds")) {
                            is Int -> v
                            is Long -> v.toInt()
                            is Double -> v.toInt()
                            else -> null
                        }
                        val openQuarantine = args?.get("openQuarantine") as? Boolean ?: false
                        showNotification(title, text, autoDismissAfterSeconds, openQuarantine)
                        result.success(true)
                    }

                    "getLaunchExtras" -> {
                        val openQ = intent?.getBooleanExtra("open_quarantine", false) ?: false
                        intent?.removeExtra("open_quarantine")
                        result.success(mapOf("open_quarantine" to openQ))
                    }

                    "showScanOngoing" -> {
                        val args = call.arguments as? Map<*, *>
                        val title = args?.get("title") as? String ?: "Scheduled scan running"
                        val text = args?.get("text") as? String ?: "Scanning files..."
                        showScanOngoingNotification(title, text)
                        result.success(true)
                    }

                    "updateScanOngoing" -> {
                        val args = call.arguments as? Map<*, *>
                        val title = args?.get("title") as? String ?: "Scheduled scan running"
                        val text = args?.get("text") as? String ?: "Scanning files..."
                        updateScanOngoingNotification(title, text)
                        result.success(true)
                    }

                    "hideScanOngoing" -> {
                        hideScanOngoingNotification()
                        result.success(true)
                    }

                    "toast" -> {
                        val args = call.arguments as? Map<*, *>
                        val text = args?.get("text") as? String ?: ""
                        if (text.isNotBlank()) {
                            android.widget.Toast.makeText(
                                applicationContext,
                                text,
                                android.widget.Toast.LENGTH_SHORT
                            ).show()
                        }
                        result.success(true)
                    }

                    else -> result.notImplemented()
                }
            }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "colourswift/storage_permission")
            .setMethodCallHandler { call, result ->
                if (call.method == "openManageStorage") {
                    try {
                        val intent = Intent(Settings.ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION)
                        intent.data = android.net.Uri.parse("package:$packageName")
                        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        startActivity(intent)
                        result.success(true)
                    } catch (e: Exception) {
                        Log.e("CSMain", "Error launching settings: ${e.message}")
                        result.error("ERROR", e.message, null)
                    }
                } else result.notImplemented()
            }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "colourswift/icon_switch")
            .setMethodCallHandler { call, _ ->
                if (call.method == "setIcon") {
                    val iconName = call.argument<String>("icon") ?: "default"
                    switchLauncherIcon(iconName)
                }
            }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "cs.manager"
        ).setMethodCallHandler(
            ManagerBridge(applicationContext)
        )

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "cs.shizuku"
        ).setMethodCallHandler(
            ShizukuBridge(applicationContext)
        )

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "cs.device_security"
        ).setMethodCallHandler(
            DeviceSecurityBridge(applicationContext)
        )

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "cs_https_cert"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "install" -> {
                    try {
                        CertService.launchInstaller(applicationContext)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("CERT_INSTALL_FAILED", e.message, null)
                    }
                }

                else -> result.notImplemented()
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "colourswift/system_watcher"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "start" -> {
                    result.success(null)
                }

                "stop" -> {
                    SystemWatcher.stop()
                    result.success(null)
                }

                "startLogs" -> {
                    SystemWatcher.enableHeuristicLogs { line ->
                        Handler(Looper.getMainLooper()).post {
                            heuristicEvents?.success(line)
                        }
                    }
                    result.success(null)
                }

                "stopLogs" -> {
                    SystemWatcher.disableHeuristicLogs()
                    result.success(null)
                }

                else -> result.notImplemented()
            }
        }

        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "colourswift/process_logs"
        ).setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                processEvents = events
                SystemWatcher.enablePollLogs { line ->
                    Handler(Looper.getMainLooper()).post {
                        processEvents?.success(line)
                    }
                }
            }

            override fun onCancel(arguments: Any?) {
                processEvents = null
                SystemWatcher.disablePollLogs()
            }
        })

        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "colourswift/heuristic_logs"
        ).setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                heuristicEvents = events
            }

            override fun onCancel(arguments: Any?) {
                heuristicEvents = null
            }
        })


        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "colourswift/watcher_state"
        ).setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                watcherStateEvents = events
                SystemWatcher.setStateSink { alive ->
                    Handler(Looper.getMainLooper()).post {
                        watcherStateEvents?.success(alive)
                    }
                }
            }

            override fun onCancel(arguments: Any?) {
                watcherStateEvents = null
                SystemWatcher.clearStateSink()
            }
        })

        ApkAnalyserBridge(applicationContext, flutterEngine.dartExecutor.binaryMessenger)
        FastAppsPlugin(applicationContext, flutterEngine.dartExecutor.binaryMessenger)

    }

    private fun startForegroundServiceCompat(title: String, text: String) {
        try {
            val intent = Intent(this, CSForegroundService::class.java)
            intent.putExtra("title", title)
            intent.putExtra("text", text)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                startForegroundService(intent)
            } else startService(intent)
            Log.i("CSMain", "Foreground service started")
        } catch (e: Exception) {
            Log.e("CSMain", "Failed to start service: ${e.message}")
        }
    }

    private fun stopForegroundService() {
        try {
            val intent = Intent(this, CSForegroundService::class.java)
            stopService(intent)
            Log.i("CSMain", "Foreground service stopped")
        } catch (e: Exception) {
            Log.e("CSMain", "Failed to stop service: ${e.message}")
        }
    }

    private fun showNotification(title: String, text: String, autoDismissAfterSeconds: Int? = null, openQuarantine: Boolean = false) {
        val channelId = "cssecurity_realtime_notify"
        val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                channelId,
                "Realtime Alerts",
                NotificationManager.IMPORTANCE_HIGH
            )
            channel.setShowBadge(false)
            manager.createNotificationChannel(channel)
        }

        val intent = Intent(this, MainActivity::class.java).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_CLEAR_TOP)
            if (openQuarantine) {
                putExtra("open_quarantine", true)
            }
        }

        val pendingIntent = PendingIntent.getActivity(
            this,
            System.currentTimeMillis().toInt(),
            intent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )

        val notification = Notification.Builder(applicationContext, channelId)
            .setContentTitle(title)
            .setContentText(text)
            .setSmallIcon(R.drawable.ic_notification)
            .setAutoCancel(true)
            .setContentIntent(pendingIntent)
            .build()

        val id = when (title) {
            "Scheduled Scan Complete" -> SCAN_NOTIF_ID + 1
            "Scheduled Scan" -> SCAN_NOTIF_ID + 2
            else -> System.currentTimeMillis().toInt()
        }

        manager.notify(id, notification)

        if (autoDismissAfterSeconds != null && autoDismissAfterSeconds > 0) {
            Handler(Looper.getMainLooper()).postDelayed({
                try {
                    manager.cancel(id)
                } catch (_: Exception) {}
            }, autoDismissAfterSeconds * 1000L)
        }
    }

    private fun ensureScanChannel(mgr: NotificationManager) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val ch = NotificationChannel(
                SCAN_NOTIF_CHANNEL,
                "Scheduled Scan",
                NotificationManager.IMPORTANCE_LOW
            )
            ch.setShowBadge(false)
            mgr.createNotificationChannel(ch)
        }
    }

    private fun scanCancelPendingIntent(): PendingIntent {
        val intent = Intent(this, MainActivity::class.java).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_CLEAR_TOP)
            putExtra(EXTRA_CANCEL_SCHEDULED_SCAN, true)
        }
        return PendingIntent.getActivity(
            this,
            8801,
            intent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )
    }

    private fun scanContentPendingIntent(): PendingIntent {
        val intent = Intent(this, MainActivity::class.java).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_CLEAR_TOP)
        }
        return PendingIntent.getActivity(
            this,
            8802,
            intent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )
    }

    private fun showScanOngoingNotification(title: String, text: String) {
        val mgr = getSystemService(NotificationManager::class.java)
        ensureScanChannel(mgr)

        val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(this, SCAN_NOTIF_CHANNEL)
        } else {
            Notification.Builder(this)
        }

        val n = builder
            .setContentTitle(title)
            .setContentText(text)
            .setSmallIcon(R.drawable.ic_notification)
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .setContentIntent(scanContentPendingIntent())
            .addAction(
                Notification.Action.Builder(
                    null,
                    "Cancel",
                    scanCancelPendingIntent()
                ).build()
            )
            .build()

        mgr.notify(SCAN_NOTIF_ID, n)
    }

    private fun updateScanOngoingNotification(title: String, text: String) {
        showScanOngoingNotification(title, text)
    }

    private fun hideScanOngoingNotification() {
        val mgr = getSystemService(NotificationManager::class.java)
        mgr.cancel(SCAN_NOTIF_ID)
    }

    private fun switchLauncherIcon(icon: String) {
        val pm = applicationContext.packageManager

        val defAlias = ComponentName(
            applicationContext,
            "com.colourswift.cssecurity.IconDefaultAlias"
        )

        val birdAlias = ComponentName(
            applicationContext,
            "com.colourswift.cssecurity.IconBirdAlias"
        )

        val neonAlias = ComponentName(
            applicationContext,
            "com.colourswift.cssecurity.IconNeonAlias"
        )

        val axAlias = ComponentName(
            applicationContext,
            "com.colourswift.cssecurity.IconAXAlias"
        )

        val avxAlias = ComponentName(
            applicationContext,
            "com.colourswift.cssecurity.IconAVXAlias"
        )


        val aAlias = ComponentName(
            applicationContext,
            "com.colourswift.cssecurity.IconAAlias"
        )

        val edrAlias = ComponentName(
            applicationContext,
            "com.colourswift.cssecurity.IconEDRAlias"
        )

        val originalAlias = ComponentName(
            applicationContext,
            "com.colourswift.cssecurity.IconOriginalAlias"
        )

        val enable = when (icon) {
            "bird" -> birdAlias
            "neon" -> neonAlias
            "ax" -> axAlias
            "avx" -> avxAlias
            "a" -> aAlias
            "edr" -> edrAlias
            "original" -> originalAlias
            else -> defAlias
        }

        val allAliases = listOf(
            defAlias,
            birdAlias,
            neonAlias,
            axAlias,
            avxAlias,
            aAlias,
            edrAlias,
            originalAlias
        )

        for (alias in allAliases) {
            pm.setComponentEnabledSetting(
                alias,
                if (alias == enable)
                    PackageManager.COMPONENT_ENABLED_STATE_ENABLED
                else
                    PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                PackageManager.DONT_KILL_APP
            )
        }
    }

    fun requestIgnoreBatteryOptimizations(context: Context) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val pm = context.getSystemService(Context.POWER_SERVICE) as PowerManager
            if (!pm.isIgnoringBatteryOptimizations(context.packageName)) {
                try {
                    val intent = Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS)
                    intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                    context.startActivity(intent)
                    Log.i("CSRealtime", "Prompting user to exempt battery optimizations")
                } catch (e: Exception) {
                    Log.e("CSRealtime", "Failed to request battery exemption: ${e.message}")
                }
            }
        }
    }

    override fun onDestroy() {
        receiver?.let {
            try {
                unregisterReceiver(it)
                Log.i("CSMain", "RealtimeReceiver unregistered on destroy")
            } catch (_: Exception) {}
            receiver = null
        }
        super.onDestroy()
    }
}