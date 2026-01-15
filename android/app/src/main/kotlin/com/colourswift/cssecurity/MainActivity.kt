package com.colourswift.cssecurity

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
import android.net.VpnService

class FastAppsPlugin(private val context: Context, messenger: BinaryMessenger) : MethodChannel.MethodCallHandler {
    private val channel = MethodChannel(messenger, "cs.fastapps")
    private val io = Executors.newSingleThreadExecutor()

    init { channel.setMethodCallHandler(this) }

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
                        Handler(Looper.getMainLooper()).post { result.success(apps) }
                    } catch (t: Throwable) {
                        Handler(Looper.getMainLooper()).post { result.error("ERR", t.message, null) }
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
    private var pendingVpnResult: MethodChannel.Result? = null
    private var pendingVpnDomain: String? = null
    private var heuristicEvents: EventChannel.EventSink? = null
    private var watcherStateEvents: EventChannel.EventSink? = null
    private var processEvents: EventChannel.EventSink? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "startService" -> {
                        val args = call.arguments as? Map<*, *>
                        val title = args?.get("title") as? String ?: "AVarionX"
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
                        val title = args?.get("title") as? String ?: "AVarionX"
                        val text = args?.get("text") as? String ?: ""
                        showNotification(title, text)
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
            "colourswift/system_watcher"
        ).setMethodCallHandler { call, result ->
            when (call.method) {

                "start" -> {
                    SystemWatcher.start(applicationContext)
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

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "cs_vpn_channel")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "checkDomain" -> {
                        val domain = call.argument<String>("domain") ?: ""
                        pendingVpnResult = result
                        pendingVpnDomain = domain
                        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "cs_vpn_callback")
                            .invokeMethod("checkDomain", mapOf("domain" to domain))
                    }
                    else -> result.notImplemented()
                }
            }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "cs_vpn_control")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "startVpn" -> {
                        val dnsMode = call.argument<String>("dns_mode") ?: "malware"

                        val intent = Intent(applicationContext, CSVpnService::class.java).apply {
                            action = CSVpnService.ACTION_START
                            putExtra("dns_mode", dnsMode)
                        }

                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                            applicationContext.startForegroundService(intent)
                        } else {
                            applicationContext.startService(intent)
                        }

                        Log.i("CSMain", "Starting VPN with dns_mode=$dnsMode")
                        result.success(true)
                    }

                    "stopVpn" -> {
                        val intent = Intent(applicationContext, CSVpnService::class.java)
                        intent.action = CSVpnService.ACTION_STOP
                        applicationContext.startService(intent)
                        result.success(true)
                    }
                }
            }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "cs_vpn_permission")
            .setMethodCallHandler { call, result ->
                if (call.method == "prepareVpn") {
                    val intent = VpnService.prepare(this)
                    if (intent != null) {
                        startActivityForResult(intent, 777)
                        result.success(false)
                    } else {
                        result.success(true)
                    }
                } else result.notImplemented()
            }

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
            "colourswift/process_logs"
        ).setStreamHandler(object : EventChannel.StreamHandler {

            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                processEvents = events

                SystemWatcher.start(applicationContext)

                SystemWatcher.enableProcessLogs { line ->
                    Handler(Looper.getMainLooper()).post {
                        processEvents?.success(line)
                    }
                }
            }

            override fun onCancel(arguments: Any?) {
                processEvents = null
                SystemWatcher.disableProcessLogs()
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

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "cs_vpn_state")
            .setMethodCallHandler { call, result ->
                if (call.method == "isAnotherVpnActive") {
                    val active = VpnService.prepare(applicationContext) != null
                    result.success(active)
                } else result.notImplemented()
            }

        FastAppsPlugin(applicationContext, flutterEngine.dartExecutor.binaryMessenger)

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    if (receiver != null) {
                        unregisterReceiver(receiver)
                        receiver = null
                    }
                    receiver = RealtimeReceiver(events)
                    val filter = IntentFilter("com.colourswift.cssecurity.NEW_FILE_DETECTED")
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                        registerReceiver(receiver, filter, Context.RECEIVER_NOT_EXPORTED)
                    } else {
                        registerReceiver(receiver, filter)
                    }
                    Log.i("CSMain", "RealtimeReceiver registered")
                }

                override fun onCancel(arguments: Any?) {
                    if (receiver != null) {
                        unregisterReceiver(receiver)
                        receiver = null
                        Log.i("CSMain", "RealtimeReceiver unregistered")
                    }
                }
            })
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

    private fun showNotification(title: String, text: String) {
        val channelId = "cssecurity_realtime_notify"
        val manager = getSystemService(Context.NOTIFICATION_SERVICE) as android.app.NotificationManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = android.app.NotificationChannel(
                channelId, "Realtime Alerts",
                android.app.NotificationManager.IMPORTANCE_HIGH
            )
            channel.setShowBadge(false)
            manager.createNotificationChannel(channel)
        }
        val notification = android.app.Notification.Builder(applicationContext, channelId)
            .setContentTitle(title)
            .setContentText(text)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setAutoCancel(true)
            .build()
        manager.notify(System.currentTimeMillis().toInt(), notification)
    }

    private fun switchLauncherIcon(icon: String) {
        val pm = applicationContext.packageManager

        val defAlias = ComponentName(applicationContext, "com.colourswift.cssecurity.IconDefaultAlias")
        val birdAlias = ComponentName(applicationContext, "com.colourswift.cssecurity.IconBirdAlias")
        val neonAlias = ComponentName(applicationContext, "com.colourswift.cssecurity.IconNeonAlias")

        val enable = when (icon) {
            "bird" -> birdAlias
            "neon" -> neonAlias
            else -> defAlias
        }

        val allAliases = listOf(defAlias, birdAlias, neonAlias)

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
