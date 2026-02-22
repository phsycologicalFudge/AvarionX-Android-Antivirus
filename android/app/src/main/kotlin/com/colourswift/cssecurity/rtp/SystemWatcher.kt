package com.colourswift.cssecurity.rtp

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
import java.io.BufferedReader
import java.io.InputStreamReader
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
    private var svc: com.colourswift.cssecurity.ISystemWatcherService? = null
    @Volatile
    private var userServiceArgs: Shizuku.UserServiceArgs? = null
    @Volatile
    private var bound = false

    @Volatile
    private var appContext: Context? = null

    private var heuristicSink: ((String) -> Unit)? = null
    private val pendingLogs = mutableListOf<String>()

    private var processSink: ((String) -> Unit)? = null

    private data class ProcMetrics(
        val pid: Int,
        val writeBytes: Long?,
        val syscw: Long?,
        val utime: Long?,
        val stime: Long?,
        val threads: Int?
    )

    private val pidLast = mutableMapOf<Int, ProcMetrics>()
    private val uidWriteWindow = mutableMapOf<Int, ArrayDeque<Long>>()
    private val uidCpuWindow = mutableMapOf<Int, ArrayDeque<Long>>()
    private val uidSyscwWindow = mutableMapOf<Int, ArrayDeque<Long>>()

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

        WatcherEngine.logSink = { line ->
            val target = heuristicSink
            if (target != null) {
                try { target(line) } catch (_: Throwable) {}
            } else {
                synchronized(pendingLogs) { pendingLogs.add(line) }
            }
        }

        WatcherEngine.onBlock = block@{ s, r ->
            val ctx = appContext ?: return@block
            blockPackage(ctx, s.packageName, r.reasons)
        }
    }

    private val conn = object : ServiceConnection {
        override fun onServiceConnected(name: ComponentName?, service: IBinder?) {
            svc = com.colourswift.cssecurity.ISystemWatcherService.Stub.asInterface(service)
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
            for (line in pendingLogs) {
                try { sink(line) } catch (_: Throwable) {}
            }
            pendingLogs.clear()
        }
    }

    fun disableHeuristicLogs() {
        heuristicSink = null
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
        try { userServiceArgs?.let { Shizuku.unbindUserService(it, conn, true) } } catch (_: Throwable) {}
        userServiceArgs = null
        svc = null
        bound = false
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
                if (output.isNullOrBlank()) {
                    emitState(false)
                    Thread.sleep(2000)
                    continue
                }

                uidActivePids.clear()

                val now = System.currentTimeMillis()

                for (line in output.lineSequence()) {
                    val parts = line.trim().split(Regex("\\s+"), limit = 3)
                    if (parts.size < 3) continue

                    val pid = parts[0].toIntOrNull() ?: continue
                    val uid = parts[1].toIntOrNull() ?: continue
                    val proc = parts[2]

                    val pkg = resolvePackageForUid(pm, uid)

                    processSink?.invoke(formatProcessLine(pid, uid, pkg, proc))

                    pidFirstSeen.putIfAbsent(pid, now)

                    val active = uidActivePids.getOrPut(uid) { mutableSetOf() }
                    active.add(pid)

                    val history = uidPidHistory.getOrPut(uid) { mutableListOf() }
                    if (!history.contains(pid)) {
                        history.add(pid)
                        if (history.size > 16) history.removeAt(0)
                    }

                    val isAppUid = uid >= 10000
                    val isUserApp = pkg != null && isUserInstalledApp(pm, pkg)

                    if (!isAppUid || !isUserApp || pkg == null) continue

                    val procRaw = try { svc?.proc(pid) } catch (_: Throwable) { null }

                    var dWrite = 0L
                    var dSyscw = 0L
                    var dCpu = 0L
                    var threads = 0
                    var uidWriteBurst = 0L
                    var uidSyscwBurst = 0L
                    var uidCpuBurst = 0L

                    if (!procRaw.isNullOrBlank()) {
                        val m = parseProc(pid, procRaw)
                        val prev = pidLast[pid]
                        if (prev != null) {
                            dWrite = ((m.writeBytes ?: 0L) - (prev.writeBytes ?: 0L)).coerceAtLeast(0L)
                            dSyscw = ((m.syscw ?: 0L) - (prev.syscw ?: 0L)).coerceAtLeast(0L)
                            dCpu = (((m.utime ?: 0L) + (m.stime ?: 0L)) - ((prev.utime ?: 0L) + (prev.stime ?: 0L))).coerceAtLeast(0L)
                        }

                        threads = (m.threads ?: 0).coerceAtLeast(0)

                        if (dWrite > 0) pushWindow(uidWriteWindow, uid, dWrite, 6)
                        if (dSyscw > 0) pushWindow(uidSyscwWindow, uid, dSyscw, 6)
                        if (dCpu > 0) pushWindow(uidCpuWindow, uid, dCpu, 6)

                        uidWriteBurst = sumWindow(uidWriteWindow, uid)
                        uidSyscwBurst = sumWindow(uidSyscwWindow, uid)
                        uidCpuBurst = sumWindow(uidCpuWindow, uid)

                        pidLast[pid] = m
                    }

                    val firstSeen = pidFirstSeen[pid] ?: now
                    val lifetimeSec = ((now - firstSeen) / 1000L).toInt().coerceAtLeast(0)

                    val churn = run {
                        val h = uidPidHistory[uid] ?: return@run 0
                        val recent = h.takeLast(10)
                        recent.distinct().size
                    }

                    val snapshot = ProcessSnapshot(
                        uid = uid,
                        pid = pid,
                        packageName = pkg,
                        processName = proc,
                        hasComponentMatch = processNameMatches(pkg, proc),
                        hasForegroundService = false,
                        timestampMs = firstSeen,
                        pidLifetimeSec = lifetimeSec,
                        deltaWriteBytes = dWrite,
                        deltaSyscw = dSyscw,
                        deltaCpuJiffies = dCpu,
                        threads = threads,
                        uidWriteBurstBytes = uidWriteBurst,
                        uidSyscwBurst = uidSyscwBurst,
                        uidCpuBurstJiffies = uidCpuBurst,
                        uidPidChurn = churn
                    )

                    WatcherEngine.evaluate(snapshot, WatcherHeuristics.ruleSet())
                }

                emitState(true)
                cleanupDeadPids(output)
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

    private fun cleanupDeadPids(psOutput: String) {
        val live = HashSet<Int>(1024)
        for (line in psOutput.lineSequence()) {
            val p = line.trim().split(Regex("\\s+"), limit = 2)
            val pid = p.firstOrNull()?.toIntOrNull() ?: continue
            live.add(pid)
        }

        val itA = pidFirstSeen.keys.iterator()
        while (itA.hasNext()) {
            val pid = itA.next()
            if (!live.contains(pid)) itA.remove()
        }

        val itB = pidLast.keys.iterator()
        while (itB.hasNext()) {
            val pid = itB.next()
            if (!live.contains(pid)) itB.remove()
        }
    }

    private fun resolvePackageForUid(pm: PackageManager, uid: Int): String? {
        return try { pm.getPackagesForUid(uid)?.firstOrNull() } catch (_: Throwable) { null }
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

    private fun formatProcessLine(pid: Int, uid: Int, pkg: String?, proc: String): String {
        val pidCol = pid.toString().padEnd(5)
        val uidCol = uid.toString().padEnd(7)
        val pkgCol = (pkg ?: "-").take(24).padEnd(24)
        val procCol = proc.take(32)
        return "$pidCol $uidCol $pkgCol $procCol"
    }

    private fun processNameMatches(pkg: String, proc: String): Boolean {
        return proc == pkg || proc.startsWith("$pkg:")
    }

    private fun parseProc(pid: Int, raw: String): ProcMetrics {
        val parts = raw.split("\n---\n")
        val io = parts.getOrNull(0) ?: ""
        val stat = parts.getOrNull(1) ?: ""
        val status = parts.getOrNull(2) ?: ""

        fun findLong(prefix: String, text: String): Long? {
            val line = text.lineSequence().firstOrNull { it.startsWith(prefix) } ?: return null
            return line.substringAfter(prefix).trim().toLongOrNull()
        }

        val writeBytes = findLong("write_bytes:", io)
        val syscw = findLong("syscw:", io)

        val statFields = stat.trim().split(Regex("\\s+"))
        val utime = statFields.getOrNull(13)?.toLongOrNull()
        val stime = statFields.getOrNull(14)?.toLongOrNull()

        val threads = status.lineSequence()
            .firstOrNull { it.startsWith("Threads:") }
            ?.substringAfter("Threads:")
            ?.trim()
            ?.toIntOrNull()

        return ProcMetrics(pid, writeBytes, syscw, utime, stime, threads)
    }

    private fun pushWindow(map: MutableMap<Int, ArrayDeque<Long>>, uid: Int, v: Long, max: Int) {
        val q = map.getOrPut(uid) { ArrayDeque() }
        q.addLast(v)
        while (q.size > max) q.removeFirst()
    }

    private fun sumWindow(map: MutableMap<Int, ArrayDeque<Long>>, uid: Int): Long {
        val q = map[uid] ?: return 0L
        var s = 0L
        for (x in q) s += x
        return s
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

    private fun blockPackage(context: Context, pkg: String, reasons: List<String>) {
        val reasonText = if (reasons.isNotEmpty()) reasons.joinToString(", ").take(140) else "ransomware-like behavior"
        runShell("am force-stop $pkg")
        runShell("cmd appops set $pkg SYSTEM_ALERT_WINDOW deny")
        runShell("pm revoke $pkg android.permission.READ_EXTERNAL_STORAGE")
        runShell("pm revoke $pkg android.permission.WRITE_EXTERNAL_STORAGE")
        runShell("pm revoke $pkg android.permission.READ_MEDIA_IMAGES")
        runShell("pm revoke $pkg android.permission.READ_MEDIA_VIDEO")
        runShell("pm revoke $pkg android.permission.READ_MEDIA_AUDIO")
        runShell("pm revoke $pkg android.permission.MANAGE_EXTERNAL_STORAGE")
        disableAccessibilityForPackage(pkg)
        notifyBlocked(context, "$pkg blocked, $reasonText")
    }

    private fun disableAccessibilityForPackage(pkg: String) {
        val cur = runShellOut("settings get secure enabled_accessibility_services").trim()
        if (cur.isBlank() || cur == "null") return

        val parts = cur.split(":").map { it.trim() }.filter { it.isNotEmpty() }
        val filtered = parts.filter { !it.startsWith("$pkg/") }
        val newValue = filtered.joinToString(":")

        runShell("settings put secure enabled_accessibility_services \"$newValue\"")

        val enabled = if (filtered.isEmpty()) "0" else "1"
        runShell("settings put secure accessibility_enabled $enabled")
    }

    private fun runShell(cmd: String): Int {
        return try { svc?.shExit(cmd) ?: -1 } catch (_: Throwable) { -1 }
    }

    private fun runShellOut(cmd: String): String {
        return try { svc?.shOut(cmd) ?: "" } catch (_: Throwable) { "" }
    }
}