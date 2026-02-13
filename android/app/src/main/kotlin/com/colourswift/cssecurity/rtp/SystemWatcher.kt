package com.colourswift.cssecurity

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.ComponentName
import android.content.Context
import android.content.ServiceConnection
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.util.Log
import androidx.core.app.NotificationCompat
import rikka.shizuku.Shizuku
import java.util.concurrent.Executors
import java.util.concurrent.atomic.AtomicBoolean

object SystemWatcher {

    private const val TAG = "SystemWatcher"
    private const val CHANNEL_ID = "cs_system_watcher"
    private const val NOTIF_ID = 2107

    private val desiredRunning = AtomicBoolean(false)
    private val loopRunning = AtomicBoolean(false)
    private val handler = Handler(Looper.getMainLooper())

    private val pidFirstSeen = mutableMapOf<Int, Long>()
    private val uidActivePids = mutableMapOf<Int, MutableSet<Int>>()
    private val uidPidHistory = mutableMapOf<Int, MutableList<Int>>()

    @Volatile
    private var executor = Executors.newSingleThreadExecutor()
    @Volatile
    private var stateSink: ((Boolean) -> Unit)? = null

    @Volatile
    private var svc: ISystemWatcherService? = null
    @Volatile
    private var userServiceArgs: Shizuku.UserServiceArgs? = null
    @Volatile
    private var bound = false

    @Volatile
    private var appContext: Context? = null

    private var heuristicSink: ((String) -> Unit)? = null
    private val pendingLogs = mutableListOf<String>()

    private var processSink: ((String) -> Unit)? = null

    private val binderReceivedListener = Shizuku.OnBinderReceivedListener {
        val ctx = appContext
        if (ctx != null && desiredRunning.get()) {
            handler.post { tryStart(ctx) }
        }
    }

    private val binderDeadListener = Shizuku.OnBinderDeadListener {
        teardownBoundService()
        emitState(false)
    }

    init {
        Shizuku.addBinderReceivedListener(binderReceivedListener)
        Shizuku.addBinderDeadListener(binderDeadListener)
    }

    private val conn = object : ServiceConnection {
        override fun onServiceConnected(name: ComponentName?, service: IBinder?) {
            svc = ISystemWatcherService.Stub.asInterface(service)
            bound = true
            emitState(true)
        }

        override fun onServiceDisconnected(name: ComponentName?) {
            svc = null
            bound = false
            emitState(false)
        }
    }

    fun start(context: Context) {
        appContext = context.applicationContext
        desiredRunning.set(true)
        tryStart(appContext!!)
    }

    fun stop() {
        desiredRunning.set(false)
        loopRunning.set(false)
        teardownBoundService()
        emitState(false)
    }

    fun enableProcessLogs(sink: (String) -> Unit) {
        processSink = sink
    }

    fun disableProcessLogs() {
        processSink = null
    }

    private fun tryStart(context: Context) {
        if (!desiredRunning.get()) return
        if (!Shizuku.pingBinder()) {
            emitState(false)
            return
        }
        if (Shizuku.checkSelfPermission() != PackageManager.PERMISSION_GRANTED) {
            emitState(false)
            return
        }

        ensureChannel(context)

        if (!bound) bind(context)

        if (!loopRunning.getAndSet(true)) {
            executor.shutdownNow()
            executor = Executors.newSingleThreadExecutor()
            executor.execute { watcherLoop(context) }
        } else {
            emitState(true)
        }
    }

    private fun teardownBoundService() {
        try { svc?.destroy() } catch (_: Throwable) {}
        try {
            userServiceArgs?.let {
                Shizuku.unbindUserService(it, conn, true)
            }
        } catch (_: Throwable) {}
        userServiceArgs = null
        svc = null
        bound = false
    }

    fun setStateSink(sink: (Boolean) -> Unit) {
        stateSink = sink
    }

    fun clearStateSink() {
        stateSink = null
    }

    private fun emitState(running: Boolean) {
        try { stateSink?.invoke(running) } catch (_: Throwable) {}
    }

    fun enableHeuristicLogs(sink: (String) -> Unit) {
        heuristicSink = sink

        synchronized(pendingLogs) {
            for (line in pendingLogs) sink(line)
            pendingLogs.clear()
        }

        WatcherHeuristics.logSink = { line ->
            val target = heuristicSink
            if (target != null) {
                target(line)
            } else {
                synchronized(pendingLogs) {
                    pendingLogs.add(line)
                }
            }
        }
    }

    fun disableHeuristicLogs() {
        heuristicSink = null
        WatcherHeuristics.logSink = null
    }

    private fun watcherLoop(context: Context) {
        val pm = context.packageManager

        while (desiredRunning.get() && loopRunning.get()) {
            try {
                if (!Shizuku.pingBinder()) {
                    emitState(false)
                    teardownBoundService()
                    Thread.sleep(2000)
                    continue
                }

                val output = svc?.ps()
                if (output == null) {
                    emitState(false)
                    Thread.sleep(2000)
                    continue
                }

                for (line in output.lineSequence()) {
                    val parts = line.trim().split(Regex("\\s+"), limit = 3)
                    if (parts.size < 3) continue

                    val pid = parts[0].toIntOrNull() ?: continue
                    val uid = parts[1].toIntOrNull() ?: continue
                    val proc = parts[2]

                    val pkg = resolvePackageForUid(pm, uid)

                    processSink?.invoke(
                        formatProcessLine(pid, uid, pkg, proc)
                    )

                    val now = System.currentTimeMillis()

                    pidFirstSeen.putIfAbsent(pid, now)

                    val active = uidActivePids.getOrPut(uid) { mutableSetOf() }
                    active.add(pid)

                    val history = uidPidHistory.getOrPut(uid) { mutableListOf() }
                    if (!history.contains(pid)) {
                        history.add(pid)
                        if (history.size > 8) {
                            history.removeAt(0)
                        }
                    }

                    val isAppUid = uid >= 10000
                    val isUserApp = pkg != null && isUserInstalledApp(pm, pkg)

                    if (!isAppUid || !isUserApp) {
                        continue
                    }

                    val snapshot = ProcessSnapshot(
                        uid = uid,
                        pid = pid,
                        packageName = pkg,
                        processName = proc,
                        hasComponentMatch = processNameMatches(pkg, proc),
                        hasForegroundService = false,
                        timestampMs = pidFirstSeen[pid] ?: now
                    )

                    val result = WatcherHeuristics.evaluate(snapshot)

                    if (result.verdict != WatcherVerdict.IGNORE) {
                        WatcherHeuristics.logSink?.invoke(
                            "verdict=${result.verdict} score=${result.score} " +
                                    "pkg=${pkg} proc=${proc}"
                        )
                    }
                }

                emitState(true)
                Thread.sleep(4000)

            } catch (_: InterruptedException) {
                loopRunning.set(false)
                return
            } catch (t: Throwable) {
                Log.e(TAG, "Watcher error", t)
                emitState(false)
                Thread.sleep(4000)
            }
        }

        loopRunning.set(false)
    }

    private fun resolvePackageForUid(pm: PackageManager, uid: Int): String? {
        return try {
            pm.getPackagesForUid(uid)?.firstOrNull()
        } catch (_: Throwable) {
            null
        }
    }

    private fun isUserInstalledApp(pm: PackageManager, pkg: String): Boolean {
        return try {
            val ai = pm.getApplicationInfo(pkg, 0)
            (ai.flags and ApplicationInfo.FLAG_SYSTEM) == 0 &&
                    (ai.flags and ApplicationInfo.FLAG_UPDATED_SYSTEM_APP) == 0
        } catch (_: Throwable) {
            false
        }
    }

    private fun formatProcessLine(
        pid: Int,
        uid: Int,
        pkg: String?,
        proc: String
    ): String {
        val pidCol = pid.toString().padEnd(5)
        val uidCol = uid.toString().padEnd(7)
        val pkgCol = (pkg ?: "-").take(24).padEnd(24)
        val procCol = proc.take(32)

        return "$pidCol $uidCol $pkgCol $procCol"
    }

    private fun processNameMatches(pkg: String, proc: String): Boolean {
        return proc == pkg || proc.startsWith("$pkg:")
    }

    private fun bind(context: Context) {
        val args = Shizuku.UserServiceArgs(
            ComponentName(context, SystemWatcherUserService::class.java)
        ).processNameSuffix("system_watcher")

        userServiceArgs = args
        Shizuku.bindUserService(args, conn)
    }

    private fun ensureChannel(context: Context) {
        if (Build.VERSION.SDK_INT < 26) return

        val nm = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        if (nm.getNotificationChannel(CHANNEL_ID) != null) return

        nm.createNotificationChannel(
            NotificationChannel(
                CHANNEL_ID,
                "Advanced Protection",
                NotificationManager.IMPORTANCE_HIGH
            )
        )
    }

    private fun notifyBlocked(context: Context, text: String) {
        handler.post {
            val nm = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            nm.notify(
                NOTIF_ID,
                NotificationCompat.Builder(context, CHANNEL_ID)
                    .setSmallIcon(android.R.drawable.stat_notify_error)
                    .setContentTitle("Suspicious activity blocked")
                    .setContentText(text)
                    .setAutoCancel(true)
                    .build()
            )
        }
    }
}
