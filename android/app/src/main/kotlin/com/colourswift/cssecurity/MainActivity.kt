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
import android.net.VpnService
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
import org.json.JSONArray
import com.colourswift.cssecurity.https.CertService
import com.colourswift.cssecurity.vpn.CSVpnService
import com.colourswift.cssecurity.rtp.SystemWatcher
import com.colourswift.cssecurity.rtp.RealtimeReceiver
import com.colourswift.cssecurity.vpn.wireguard.CSWireGuardService
import com.colourswift.cssecurity.vpn.VpnModeSwitcher
import androidx.core.content.ContextCompat
import com.colourswift.cssecurity.apkanalyser.ApkAnalyserBridge

object CsDnsEvents {
    private const val MAX = 800

    private val lock = Any()
    private val buffer = ArrayDeque<Map<String, Any?>>(MAX)
    private val vpnStateChannel = "cs_vpn_lockdown"
    private val main = Handler(Looper.getMainLooper())
    private val sinks = LinkedHashSet<EventChannel.EventSink>()

    fun addSink(s: EventChannel.EventSink?) {
        if (s == null) return

        val snapshot: List<Map<String, Any?>> = synchronized(lock) {
            sinks.add(s)
            buffer.toList()
        }

        main.post {
            for (e in snapshot) {
                try { s.success(e) } catch (_: Exception) {}
            }
        }
    }

    fun removeSink(s: EventChannel.EventSink?) {
        if (s == null) return
        synchronized(lock) {
            sinks.remove(s)
        }
    }

    fun emit(map: Map<String, Any?>) {
        val targets: List<EventChannel.EventSink>
        synchronized(lock) {
            if (buffer.size >= MAX) buffer.removeFirst()
            buffer.addLast(map)
            targets = sinks.toList()
        }

        if (targets.isEmpty()) return

        main.post {
            for (t in targets) {
                try { t.success(map) } catch (_: Exception) {}
            }
        }
    }
}

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

            "getWifiBlockedPkgs" -> {
                io.execute {
                    try {
                        val set = AppWifiRules.getWifiBlockedPkgs(context).toList().sorted()
                        Handler(Looper.getMainLooper()).post { result.success(set) }
                    } catch (t: Throwable) {
                        Handler(Looper.getMainLooper()).post {
                            result.error("ERR", t.message, null)
                        }
                    }
                }
            }

            "setAppWifiBlock" -> {
                io.execute {
                    try {
                        val pkg = call.argument<String>("package") ?: ""
                        val blocked = call.argument<Boolean>("blocked") ?: false
                        val ok = AppWifiRules.setWifiBlocked(context, pkg, blocked)

                        try {
                            val i = Intent(context, CSVpnService::class.java).apply {
                                action = CSVpnService.ACTION_START
                                putExtra("dns_mode", "cloud")
                                putExtra("reload_rules", true)
                            }
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                                context.startForegroundService(i)
                            } else {
                                context.startService(i)
                            }
                        } catch (_: Exception) {}

                        Handler(Looper.getMainLooper()).post { result.success(ok) }
                    } catch (t: Throwable) {
                        Handler(Looper.getMainLooper()).post {
                            result.error("ERR", t.message, null)
                        }
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
    private var heuristicEvents: EventChannel.EventSink? = null
    private var watcherStateEvents: EventChannel.EventSink? = null
    private var processEvents: EventChannel.EventSink? = null
    private var fe: FlutterEngine? = null

    private val SCAN_NOTIF_ID = 201
    private val SCAN_NOTIF_CHANNEL = "cssecurity_scan_status"
    private val EXTRA_CANCEL_SCHEDULED_SCAN = "cancel_scheduled_scan"

    private val FULLVPN_CHAN = "cs_fullvpn"
    private val REQ_VPN = 9911
    private var pendingWgConfig: String? = null

    private val VPN_REQ_CODE = 777
    private var pendingVpnPermissionResult: MethodChannel.Result? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
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

        if (requestCode == REQ_VPN) {
            val cfg = pendingWgConfig
            pendingWgConfig = null
            if (resultCode == RESULT_OK && cfg != null) {
                startWgService(cfg)
            }
            return
        }

        if (requestCode != VPN_REQ_CODE) return
        val ok = resultCode == RESULT_OK
        pendingVpnPermissionResult?.success(ok)
        pendingVpnPermissionResult = null
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        fe = flutterEngine

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            FULLVPN_CHAN
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "connect" -> {
                    val cfg = call.arguments as? String ?: ""
                    if (cfg.isBlank()) {
                        result.error("bad_args", "missing config", null)
                        return@setMethodCallHandler
                    }

                    val prep = VpnService.prepare(this)
                    if (prep != null) {
                        pendingWgConfig = cfg
                        startActivityForResult(prep, REQ_VPN)
                        result.success(mapOf("permission" to true, "started" to false))
                        return@setMethodCallHandler
                    }

                    startWgService(cfg)
                    result.success(mapOf("permission" to false, "started" to true))
                }

                "disconnect" -> {
                    stopWgService()
                    result.success(true)
                }

                else -> result.notImplemented()
            }
        }

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
                    "checkConnection" -> {
                        pendingVpnResult = result
                        val ip = call.argument<String>("ip") ?: ""
                        val sni = call.argument<String>("sni") ?: ""
                        val port = call.argument<Int>("port") ?: 443
                        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "cs_vpn_callback")
                            .invokeMethod(
                                "checkConnection",
                                mapOf(
                                    "ip" to ip,
                                    "sni" to sni,
                                    "port" to port
                                )
                            )
                    }

                    else -> result.notImplemented()
                }
            }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "cs_vpn_callback")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "replyCheckConnection" -> {
                        val code = call.argument<Int>("code") ?: 0
                        val r = pendingVpnResult
                        pendingVpnResult = null
                        try {
                            r?.success(code)
                        } catch (_: Exception) {
                        }
                        result.success(true)
                    }

                    else -> result.notImplemented()
                }
            }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "cs_vpn_control")
            .setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
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
                        result.success(true)
                    }

                    "stopVpn" -> {
                        val intent = Intent(applicationContext, CSVpnService::class.java)
                        intent.action = CSVpnService.ACTION_STOP
                        applicationContext.startService(intent)
                        result.success(true)
                    }

                    "startWireGuard" -> {
                        val config = call.argument<String>("config") ?: ""
                        if (config.isBlank()) {
                            result.error("WG_CONFIG_MISSING", "WireGuard config missing", null)
                            return@setMethodCallHandler
                        }

                        VpnModeSwitcher.stopDnsVpn(applicationContext)
                        VpnModeSwitcher.stopWireGuard(applicationContext)

                        Handler(Looper.getMainLooper()).postDelayed({
                            VpnModeSwitcher.startWireGuard(applicationContext, config)
                        }, 650)

                        result.success(true)
                    }

                    "stopWireGuard" -> {
                        val intent =
                            Intent(applicationContext, CSWireGuardService::class.java).apply {
                                action = CSWireGuardService.ACTION_STOP
                            }
                        applicationContext.startService(intent)
                        result.success(true)
                    }

                    "isWireGuardRunning" -> {
                        result.success(CSWireGuardService.isRunning)
                    }

                    "isDnsVpnRunning" -> {
                        result.success(CSVpnService.isRunning)
                    }

                    else -> result.notImplemented()
                }
            }

        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "cs_dns_events"
        ).setStreamHandler(object : EventChannel.StreamHandler {
            private var sink: EventChannel.EventSink? = null

            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                sink = events
                CsDnsEvents.addSink(events)
            }

            override fun onCancel(arguments: Any?) {
                CsDnsEvents.removeSink(sink)
                sink = null
            }
        })

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "cs_dns_settings"
        ).setMethodCallHandler { call, result ->
            if (call.method != "setCloudSettings") {
                result.notImplemented()
                return@setMethodCallHandler
            }

            val args = call.arguments as? Map<*, *>
            val enabledLists = args?.get("enabled_lists") as? List<*>
            val resolver = (args?.get("resolver") as? String)?.trim().orEmpty()
            val plan = (args?.get("plan") as? String)?.trim()?.lowercase().orEmpty()
            val cloudUrl = (args?.get("cloud_url") as? String)?.trim().orEmpty()
            val clientId = (args?.get("client_id") as? String)?.trim().orEmpty()

            val prefs =
                applicationContext.getSharedPreferences("cs_dns_cloud", Context.MODE_PRIVATE)
            val ed = prefs.edit()

            if (enabledLists != null) {
                val arr = JSONArray()
                enabledLists.forEach { v ->
                    val s = v?.toString()?.trim().orEmpty()
                    if (s.isNotEmpty()) arr.put(s)
                }
                ed.putString("enabled_lists_json", arr.toString())
            }

            if (resolver.isNotEmpty()) ed.putString("resolver", resolver)
            if (plan == "pro" || plan == "free") ed.putString("plan", plan)
            if (cloudUrl.isNotEmpty()) ed.putString("cloud_url", cloudUrl)
            if (clientId.isNotEmpty()) ed.putString("client_id", clientId)

            ed.commit()
            result.success(true)
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "cs_dns_usage"
        ).setMethodCallHandler { call, result ->
            if (call.method != "getUsage") {
                result.notImplemented()
                return@setMethodCallHandler
            }

            val prefs =
                applicationContext.getSharedPreferences("cs_dns_cloud", Context.MODE_PRIVATE)

            val used = prefs.getLong("usage_used", 0L).toInt()
            val limit = prefs.getLong("usage_limit", -1L).toInt().let { if (it <= 0) null else it }
            val resetMs = prefs.getLong("usage_reset_ms", -1L).let { if (it <= 0L) null else it }
            val plan = prefs.getString("plan", "free") ?: "free"

            val out = HashMap<String, Any?>()
            out["used"] = used
            out["limit"] = limit
            out["reset_ms"] = resetMs
            out["plan"] = plan

            result.success(out)
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "cs_vpn_permission")
            .setMethodCallHandler { call, result ->
                if (call.method == "prepareVpn") {
                    val intent = VpnService.prepare(this)
                    if (intent != null) {
                        pendingVpnPermissionResult = result
                        startActivityForResult(intent, VPN_REQ_CODE)
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

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "cs_vpn_lockdown")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getLockdownState" -> {
                        try {
                            result.success(CSVpnService.snapshotLockdownState(applicationContext))
                        } catch (_: Exception) {
                            result.success(
                                mapOf(
                                    "always_on" to false,
                                    "lockdown" to false,
                                    "always_on_pkg" to null
                                )
                            )
                        }
                    }

                    "openVpnSettings" -> {
                        try {
                            val i = Intent(Settings.ACTION_VPN_SETTINGS)
                            i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                            startActivity(i)
                            result.success(true)
                        } catch (_: Exception) {
                            result.success(false)
                        }
                    }

                    else -> result.notImplemented()
                }
            }

        ApkAnalyserBridge(applicationContext, flutterEngine.dartExecutor.binaryMessenger)
        FastAppsPlugin(applicationContext, flutterEngine.dartExecutor.binaryMessenger)

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    if (receiver != null) {
                        unregisterReceiver(receiver)
                        receiver = null
                    }
                    RealtimeReceiver.events = events
                    receiver = RealtimeReceiver()
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
                    RealtimeReceiver.events = null
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

    private fun startWgService(cfg: String) {
        val i = Intent(this, com.colourswift.cssecurity.vpn.wireguard.CSWireGuardService::class.java).apply {
            action = com.colourswift.cssecurity.vpn.wireguard.CSWireGuardService.ACTION_START
            putExtra(com.colourswift.cssecurity.vpn.wireguard.CSWireGuardService.EXTRA_WG_CONFIG, cfg)
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            ContextCompat.startForegroundService(this, i)
        } else {
            startService(i)
        }
    }

    private fun stopWgService() {
        val i = Intent(this, com.colourswift.cssecurity.vpn.wireguard.CSWireGuardService::class.java).apply {
            action = com.colourswift.cssecurity.vpn.wireguard.CSWireGuardService.ACTION_STOP
        }
        startService(i)
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

        val n = Notification.Builder(this, SCAN_NOTIF_CHANNEL)
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

        val enable = when (icon) {
            "bird" -> birdAlias
            "neon" -> neonAlias
            "ax" -> axAlias
            "avx" -> avxAlias
            else -> defAlias
        }

        val allAliases = listOf(
            defAlias,
            birdAlias,
            neonAlias,
            axAlias,
            avxAlias
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
