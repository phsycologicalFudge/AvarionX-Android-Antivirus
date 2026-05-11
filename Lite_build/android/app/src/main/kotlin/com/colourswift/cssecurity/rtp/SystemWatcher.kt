package com.colourswift.cssecurity.rtp

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Intent
import android.os.Build
import android.content.Context
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.util.Log
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.delay
import kotlinx.coroutines.isActive
import kotlinx.coroutines.launch
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import java.util.concurrent.ConcurrentHashMap

class SystemWatcher(private val context: Context) {

    private var service: com.colourswift.cssecurity.ISystemWatcherService? = null
    private val scope = CoroutineScope(Dispatchers.IO + SupervisorJob())

    companion object {
        private const val DANGEROUS_FS_MIN_CPU = 100L

        private var instance: SystemWatcher? = null

        @Volatile private var heuristicSink: ((String) -> Unit)? = null
        @Volatile private var processSink: ((String) -> Unit)? = null
        @Volatile private var pollSink: ((String) -> Unit)? = null
        @Volatile private var stateSink: ((Boolean) -> Unit)? = null

        fun start(context: Context, service: com.colourswift.cssecurity.ISystemWatcherService) {
            if (instance != null) return

            val w = SystemWatcher(context.applicationContext)
            w.bind(service)

            w.onEscalate = { pid, uid, pkg ->
                val msg = "[${timestamp()}] ALERT · pkg=$pkg · pid=$pid · uid=$uid"
                heuristicSink?.invoke(msg)
                processSink?.invoke(msg)
            }

            w.onBlock = { pid, uid, pkg ->
                val msg = "[${timestamp()}] THREAT BLOCKED · pkg=$pkg · pid=$pid · uid=$uid"
                heuristicSink?.invoke(msg)
                processSink?.invoke(msg)
                sendThreatNotification(context.applicationContext, pkg)
            }

            instance = w
            w.startPolling(intervalMs = 1500L)
            stateSink?.invoke(true)
        }

        private fun sendThreatNotification(context: Context, pkg: String) {
            try {
                val channelId = "cssecurity_threats"
                val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    val channel = NotificationChannel(
                        channelId,
                        "Threat Alerts",
                        NotificationManager.IMPORTANCE_HIGH,
                    ).apply {
                        setShowBadge(true)
                        enableVibration(true)
                        lockscreenVisibility = Notification.VISIBILITY_PUBLIC
                    }
                    manager.createNotificationChannel(channel)
                }

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    val granted = context.checkSelfPermission(android.Manifest.permission.POST_NOTIFICATIONS) ==
                            PackageManager.PERMISSION_GRANTED
                    if (!granted) return
                }

                val label = try {
                    context.packageManager.getApplicationLabel(
                        context.packageManager.getApplicationInfo(pkg, 0)
                    ).toString()
                } catch (_: Throwable) {
                    pkg
                }

                val intent = Intent(context, com.colourswift.cssecurity.MainActivity::class.java)
                val pendingIntent = PendingIntent.getActivity(
                    context,
                    3000 + (pkg.hashCode() and 0xFFFF),
                    intent,
                    PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
                )

                val notification = Notification.Builder(context, channelId)
                    .setContentTitle("Threat blocked")
                    .setContentText("$label was stopped by real-time protection")
                    .setSmallIcon(com.colourswift.cssecurity.R.drawable.ic_notification)
                    .setContentIntent(pendingIntent)
                    .setPriority(Notification.PRIORITY_HIGH)
                    .setCategory(Notification.CATEGORY_ALARM)
                    .setAutoCancel(true)
                    .build()

                val notifId = 1000 + (pkg.hashCode() and 0xFFFF)
                manager.notify(notifId, notification)
            } catch (t: Throwable) {
                Log.e("SystemWatcher", "Threat notification failed: ${t.javaClass.simpleName}: ${t.message}")
            }
        }

        fun stop() {
            instance?.stop()
            instance = null
            stateSink?.invoke(false)
        }

        fun isRunning(): Boolean {
            return instance != null
        }

        fun enableHeuristicLogs(sink: (String) -> Unit) {
            heuristicSink = sink
        }

        fun disableHeuristicLogs() {
            heuristicSink = null
        }

        fun enableProcessLogs(sink: (String) -> Unit) {
            processSink = sink
        }

        fun disableProcessLogs() {
            processSink = null
        }

        fun enablePollLogs(sink: (String) -> Unit) {
            pollSink = sink
        }

        fun disablePollLogs() {
            pollSink = null
        }

        fun setStateSink(sink: (Boolean) -> Unit) {
            stateSink = sink
            stateSink?.invoke(instance != null)
        }

        fun clearStateSink() {
            stateSink = null
        }
    }

    private data class PidState(
        val uid: Int,
        val firstSeenMs: Long,
        var lastWriteBytes: Long = 0L,
        var lastSyscw: Long = 0L,
        var lastCpuJiffies: Long = 0L,
    )

    private data class UidBurst(
        var writeBytesWindow: Long = 0L,
        var syscwWindow: Long = 0L,
        var cpuJiffiesWindow: Long = 0L,
        var pidsExpired: Int = 0,
    )

    private data class FsMetrics(
        val baseline: Int = 0,
        val truncated: Int = 0,
        val filesScanned: Int = 0,
        val totalEvents: Int = 0,
        val createCount: Int = 0,
        val modifyCount: Int = 0,
        val deleteCount: Int = 0,
        val suspiciousExtCount: Int = 0,
        val lockedExtCount: Int = 0,
        val copyLikeCount: Int = 0,
        val encryptLikeCount: Int = 0,
        val sourceOnlyCount: Int = 0,
        val totalBytesChanged: Long = 0L,
        val uniqueDirsTouched: Int = 0,
        val uniqueExtTouched: Int = 0,
    )

    private data class FdMatch(
        val pid: Int,
        val uid: Int,
        val path: String,
    )

    private data class ProcessFrame(
        val pid: Int,
        val uid: Int,
        val procName: String,
        val pkg: String,
        val isSystem: Boolean,
        val hasFg: Boolean,
        val hasComp: Boolean,
        val lifetimeSec: Int,
        val threads: Int,
        val writeBytes: Long,
        val syscw: Long,
        val deltaWrite: Long,
        val deltaSyscw: Long,
        val deltaCpu: Long,
        val burstWrite: Long,
        val burstSyscw: Long,
        val burstCpu: Long,
        val pidChurn: Int,
        val parsed: String,
        val ioOk: Long,
        val statOk: Long,
        val statusOk: Long,
    )

    private data class FsAttribution(
        val mode: String,
        val ownerUid: Int? = null,
    )

    private val pidStates = ConcurrentHashMap<Int, PidState>()
    private val uidBursts = ConcurrentHashMap<Int, UidBurst>()
    private val uidFdScores = ConcurrentHashMap<Int, Int>()
    private val deviceAdminPackages = mutableSetOf<String>()

    @Volatile private var screenLocked = false

    private val recentlyBlockedUids = ConcurrentHashMap<Int, Long>()
    private var stickyFsOwner: Pair<Int, Long>? = null
    private val topCpuFsHistory = ArrayDeque<Int>()
    private var noFsEventPollCount = 0

    var onEscalate: ((pid: Int, uid: Int, pkg: String) -> Unit)? = null
    var onBlock: ((pid: Int, uid: Int, pkg: String) -> Unit)? = null

    fun bind(svc: com.colourswift.cssecurity.ISystemWatcherService) {
        service = svc
    }

    fun startPolling(intervalMs: Long = 3000L) {
        scope.launch {
            while (isActive) {
                poll()
                delay(intervalMs)
            }
        }
    }

    fun stop() {
        scope.cancel()
        pidStates.clear()
        uidBursts.clear()
        uidFdScores.clear()
        deviceAdminPackages.clear()
        screenLocked = false
        recentlyBlockedUids.clear()
        stickyFsOwner = null
        topCpuFsHistory.clear()
        noFsEventPollCount = 0
    }

    private fun poll() {
        val svc = service ?: return

        Log.d("SystemWatcher", "poll() firing")

        val pm = context.packageManager
        val nowMs = System.currentTimeMillis()
        val watchedRoot = "/storage/emulated/0"

        refreshScreenLock(svc)
        refreshDeviceAdminPackages(svc)

        val psOut = try {
            svc.ps()
        } catch (_: Throwable) {
            return
        }

        val fsMetrics = collectExternalMetrics(
            svc = svc,
            root = watchedRoot,
            maxFiles = 80000,
        )

        uidFdScores.clear()

        val fdMatches = if (fsMetrics.totalEvents > 0) collectFdMatches(svc) else emptyList()

        for (match in fdMatches) {
            uidFdScores[match.uid] = (uidFdScores[match.uid] ?: 0) + 1
        }

        if (fsMetrics.baseline == 1) {
            Log.d("SystemWatcher", "FS_BASELINE files=${fsMetrics.filesScanned} root=$watchedRoot truncated=${fsMetrics.truncated}")
        }

        if (fsMetrics.totalEvents > 0) {
            Log.d(
                "SystemWatcher",
                "FS_TOTAL events=${fsMetrics.totalEvents} create=${fsMetrics.createCount} modify=${fsMetrics.modifyCount} delete=${fsMetrics.deleteCount} suspicious=${fsMetrics.suspiciousExtCount} locked=${fsMetrics.lockedExtCount} copyLike=${fsMetrics.copyLikeCount} encryptLike=${fsMetrics.encryptLikeCount} sourceOnly=${fsMetrics.sourceOnlyCount} bytes=${fsMetrics.totalBytesChanged} dirs=${fsMetrics.uniqueDirsTouched} exts=${fsMetrics.uniqueExtTouched} files=${fsMetrics.filesScanned} truncated=${fsMetrics.truncated} fdMatches=${fdMatches.size}"
            )
        }

        for (burst in uidBursts.values) {
            burst.writeBytesWindow = 0L
            burst.syscwWindow = 0L
            burst.cpuJiffiesWindow = 0L
            burst.pidsExpired = 0
        }

        val currentPids = mutableSetOf<Int>()
        val activeUids = mutableSetOf<Int>()
        val frames = mutableListOf<ProcessFrame>()

        for (line in psOut.lines()) {
            val parts = line.trim().split("\\s+".toRegex())
            if (parts.size < 3) continue

            val pid = parts[0].toIntOrNull() ?: continue
            val uid = parts[1].toIntOrNull() ?: continue
            if (uid == 0) continue

            val procName = parts[2]
            if (procName.startsWith("[")) continue

            currentPids.add(pid)
            activeUids.add(uid)

            val parsed = try {
                svc.procParsed(pid)
            } catch (t: Throwable) {
                Log.d("SystemWatcher", "procParsed failed pid=$pid uid=$uid proc=$procName err=${t.javaClass.simpleName}:${t.message}")
                continue
            }

            val fields = parseKv(parsed)
            val ioOk = fields["ioOk"] ?: 1L
            val statOk = fields["statOk"] ?: 1L
            val statusOk = fields["statusOk"] ?: 1L

            val writeBytes = fields["wb"] ?: 0L
            val syscw = fields["syscw"] ?: 0L
            val cpuJiffies = (fields["utime"] ?: 0L) + (fields["stime"] ?: 0L)
            val threads = fields["thr"]?.toInt() ?: 0

            val existingState = pidStates[pid]

            if (existingState != null && existingState.uid != uid) {
                uidBursts[existingState.uid]?.pidsExpired =
                    (uidBursts[existingState.uid]?.pidsExpired ?: 0) + 1
                pidStates.remove(pid)
            }

            val state = pidStates.getOrPut(pid) {
                PidState(uid = uid, firstSeenMs = nowMs)
            }

            val burst = uidBursts.getOrPut(uid) {
                UidBurst()
            }

            val deltaWrite = (writeBytes - state.lastWriteBytes).coerceAtLeast(0L)
            val deltaSyscw = (syscw - state.lastSyscw).coerceAtLeast(0L)
            val deltaCpu = (cpuJiffies - state.lastCpuJiffies).coerceAtLeast(0L)

            state.lastWriteBytes = writeBytes
            state.lastSyscw = syscw
            state.lastCpuJiffies = cpuJiffies

            burst.writeBytesWindow += deltaWrite
            burst.syscwWindow += deltaSyscw
            burst.cpuJiffiesWindow += deltaCpu

            val lifetimeSec = ((nowMs - state.firstSeenMs) / 1000L).toInt()
            val (pkg, hasFg, hasComp) = resolvePackage(pm, uid, procName)
            val isSystem = isSystemPackage(pm, pkg)

            if ((ioOk == 0L || statOk == 0L || statusOk == 0L) && pkg.contains("colourswift", ignoreCase = true)) {
                Log.d("SystemWatcher", "proc read issue pid=$pid uid=$uid proc=$procName parsed=$parsed")
            }

            frames.add(
                ProcessFrame(
                    pid = pid,
                    uid = uid,
                    procName = procName,
                    pkg = pkg,
                    isSystem = isSystem,
                    hasFg = hasFg,
                    hasComp = hasComp,
                    lifetimeSec = lifetimeSec,
                    threads = threads,
                    writeBytes = writeBytes,
                    syscw = syscw,
                    deltaWrite = deltaWrite,
                    deltaSyscw = deltaSyscw,
                    deltaCpu = deltaCpu,
                    burstWrite = burst.writeBytesWindow,
                    burstSyscw = burst.syscwWindow,
                    burstCpu = burst.cpuJiffiesWindow,
                    pidChurn = burst.pidsExpired,
                    parsed = parsed,
                    ioOk = ioOk,
                    statOk = statOk,
                    statusOk = statusOk,
                )
            )
        }

        var shadowSuppressedThisPoll = false
        val fsAttribution = run {
            val shadowIter = recentlyBlockedUids.entries.iterator()
            while (shadowIter.hasNext()) {
                if (nowMs - shadowIter.next().value > 6_000L) shadowIter.remove()
            }
            val shadowSuppressed = recentlyBlockedUids.keys.any { uid -> !activeUids.contains(uid) }
            val raw = selectFsAttribution(frames, fsMetrics, uidFdScores, activeUids, nowMs)
            if (shadowSuppressed && raw.mode != "none") {
                Log.d("SystemWatcher", "FS_SHADOW_SUPPRESS mode=${raw.mode} ownerUid=${raw.ownerUid ?: -1} events=${fsMetrics.totalEvents}")
                shadowSuppressedThisPoll = true
                stickyFsOwner = null
                topCpuFsHistory.clear()
                FsAttribution("none")
            } else raw
        }

        if (fsMetrics.totalEvents > 0) {
            Log.d(
                "SystemWatcher",
                "FS_ATTRIB_MODE mode=${fsAttribution.mode} ownerUid=${fsAttribution.ownerUid ?: -1} events=${fsMetrics.totalEvents} encrypt=${fsMetrics.encryptLikeCount} locked=${fsMetrics.lockedExtCount} suspicious=${fsMetrics.suspiciousExtCount}"
            )
        }

        for (frame in frames) {
            val hasFdAttribution = (uidFdScores[frame.uid] ?: 0) > 0
            val receivesFsMetrics = when (fsAttribution.mode) {
                "fd", "inferred" -> fsAttribution.ownerUid == frame.uid
                "broadcast" -> isAttributionCandidate(frame) && frame.deltaCpu >= minimumCpuForFs(fsMetrics)
                else -> false
            }
            val weakFsAttribution = fsAttribution.mode == "broadcast" && receivesFsMetrics
            val effectiveFsMetrics = if (receivesFsMetrics) fsMetrics else FsMetrics()

            val result = WatcherJni.watcherEvaluate(
                uid = frame.uid,
                pid = frame.pid,
                lifetimeSec = frame.lifetimeSec,
                threads = frame.threads,
                pidChurn = frame.pidChurn,
                fg = if (frame.hasFg) 1 else 0,
                comp = if (frame.hasComp) 1 else 0,
                deltaWrite = frame.deltaWrite,
                deltaSyscw = frame.deltaSyscw,
                deltaCpu = frame.deltaCpu,
                burstWrite = frame.burstWrite,
                burstSyscw = frame.burstSyscw,
                burstCpu = frame.burstCpu,
                fsEventsTotal = effectiveFsMetrics.totalEvents,
                fsCreateCount = effectiveFsMetrics.createCount,
                fsModifyCount = effectiveFsMetrics.modifyCount,
                fsDeleteCount = effectiveFsMetrics.deleteCount,
                fsSuspiciousExtCount = effectiveFsMetrics.suspiciousExtCount,
                fsLockedExtCount = effectiveFsMetrics.lockedExtCount,
                fsCopyLikeCount = effectiveFsMetrics.copyLikeCount,
                fsEncryptLikeCount = effectiveFsMetrics.encryptLikeCount,
                fsSourceOnlyCount = effectiveFsMetrics.sourceOnlyCount,
                fsTotalBytesChanged = effectiveFsMetrics.totalBytesChanged,
                fsUniqueDirsTouched = effectiveFsMetrics.uniqueDirsTouched,
                fsUniqueExtTouched = effectiveFsMetrics.uniqueExtTouched,
                screenLocked = if (screenLocked) 1 else 0,
                deviceAdmin = if (deviceAdminPackages.contains(frame.pkg)) 1 else 0,
                pkgNameEntropy = packageNameEntropy(frame.pkg),
            )

            var verdict = WatcherJni.unpackVerdict(result)

            if (weakFsAttribution) {
                val hasCorroboratingIo = frame.deltaWrite > 0 || frame.deltaSyscw > 0
                if (verdict == 2 || (verdict == 1 && !hasCorroboratingIo)) {
                    Log.d(
                        "SystemWatcher",
                        "FS_WEAK_DOWNGRADE uid=${frame.uid} pkg=${frame.pkg} verdict=$verdict corrobIo=$hasCorroboratingIo fsEvents=${effectiveFsMetrics.totalEvents}"
                    )
                    verdict = if (hasCorroboratingIo) 1 else 0
                }
            }

            if (
                frame.pkg.contains("colourswift_manager", ignoreCase = true) ||
                frame.pkg.contains("avarionx.manager", ignoreCase = true)
            ) {
                Log.d(
                    "SystemWatcher",
                    "TARGET pid=${frame.pid} uid=${frame.uid} pkg=${frame.pkg} verdict=$verdict wb=${frame.writeBytes} dw=${frame.deltaWrite} syscw=${frame.syscw} dsyscw=${frame.deltaSyscw} fsEvents=${effectiveFsMetrics.totalEvents} fsCreate=${effectiveFsMetrics.createCount} fsModify=${effectiveFsMetrics.modifyCount} fsDelete=${effectiveFsMetrics.deleteCount} fsSuspicious=${effectiveFsMetrics.suspiciousExtCount} fsLocked=${effectiveFsMetrics.lockedExtCount} fsCopy=${effectiveFsMetrics.copyLikeCount} fsEncrypt=${effectiveFsMetrics.encryptLikeCount} fsSource=${effectiveFsMetrics.sourceOnlyCount} fsBytes=${effectiveFsMetrics.totalBytesChanged} fdOwner=$hasFdAttribution weakFs=$weakFsAttribution bw=${frame.burstWrite} bsyscw=${frame.burstSyscw} parsed=${frame.parsed}"
                )
            }

            if (effectiveFsMetrics.totalEvents > 0) {
                Log.d(
                    "SystemWatcher",
                    "FS_ATTRIB uid=${frame.uid} pkg=${frame.pkg} pid=${frame.pid} mode=${fsAttribution.mode} fdOwner=$hasFdAttribution weak=$weakFsAttribution events=${effectiveFsMetrics.totalEvents} encrypt=${effectiveFsMetrics.encryptLikeCount} locked=${effectiveFsMetrics.lockedExtCount} suspicious=${effectiveFsMetrics.suspiciousExtCount} deltaCpu=${frame.deltaCpu}"
                )
            }

            val label = when (verdict) {
                2 -> {
                    recentlyBlockedUids[frame.uid] = nowMs
                    if (stickyFsOwner?.first == frame.uid) stickyFsOwner = null
                    topCpuFsHistory.removeAll { it == frame.uid }
                    onBlock?.invoke(frame.pid, frame.uid, frame.pkg)

                    if (!frame.isSystem) {
                        forceStop(frame.pid, frame.pkg)
                    }

                    "THREAT BLOCKED"
                }
                1 -> {
                    onEscalate?.invoke(frame.pid, frame.uid, frame.pkg)
                    "ALERT"
                }
                else -> null
            }

            val display = label ?: "CLEAN"
            pollSink?.invoke("[${timestamp()}] $display · pkg=${frame.pkg} · pid=${frame.pid} · uid=${frame.uid}")
        }

        val expired = pidStates.keys - currentPids

        for (pid in expired) {
            val st = pidStates.remove(pid) ?: continue
            uidBursts[st.uid]?.pidsExpired = (uidBursts[st.uid]?.pidsExpired ?: 0) + 1
        }

        val deadUids = uidBursts.keys - activeUids

        for (uid in deadUids) {
            uidBursts.remove(uid)
        }

        if (fsMetrics.totalEvents > 0 && !shadowSuppressedThisPoll) {
            noFsEventPollCount = 0
            val minCpuForHist = minimumCpuForFs(fsMetrics)
            val topUid = frames
                .filter { frame -> isAttributionCandidate(frame) && frame.deltaCpu >= minCpuForHist }
                .maxByOrNull { it.deltaCpu }
                ?.uid
            if (topUid != null) {
                topCpuFsHistory.addLast(topUid)
                while (topCpuFsHistory.size > 4) topCpuFsHistory.removeFirst()
            }
        } else if (fsMetrics.totalEvents == 0) {
            noFsEventPollCount++
            if (noFsEventPollCount >= 3) {
                topCpuFsHistory.clear()
                noFsEventPollCount = 0
            }
        }
    }

    private fun refreshScreenLock(svc: com.colourswift.cssecurity.ISystemWatcherService) {
        screenLocked = try {
            val out = svc.shOut("dumpsys window | grep -E 'mShowingLockscreen|mDreamingLockscreen'")
            out.contains("mShowingLockscreen=true") || out.contains("mDreamingLockscreen=true")
        } catch (_: Throwable) {
            false
        }
    }

    private fun refreshDeviceAdminPackages(svc: com.colourswift.cssecurity.ISystemWatcherService) {
        deviceAdminPackages.clear()
        try {
            val out = svc.shOut("dumpsys device_policy")
            val regex = Regex("ComponentInfo\\{([^/}]+)/")
            for (match in regex.findAll(out)) {
                deviceAdminPackages.add(match.groupValues[1].trim())
            }
        } catch (_: Throwable) {
        }
    }

    private fun packageNameEntropy(pkg: String): Int {
        val segments = pkg.split('.')
        if (segments.size < 2) return 0

        val relevant = segments.drop(1).joinToString("")
        if (relevant.isEmpty()) return 0

        val digits = relevant.count { it.isDigit() }
        return ((digits.toFloat() / relevant.length) * 100).toInt()
    }

    private fun collectExternalMetrics(
        svc: com.colourswift.cssecurity.ISystemWatcherService,
        root: String,
        maxFiles: Int,
    ): FsMetrics {
        val summary = try {
            svc.externalSnapshot(root, maxFiles)
        } catch (t: Throwable) {
            Log.d("SystemWatcher", "FS_SUMMARY_ERR root=$root err=${t.javaClass.simpleName}:${t.message}")
            return FsMetrics()
        }

        if (summary.isBlank()) {
            Log.d("SystemWatcher", "FS_SUMMARY_EMPTY root=$root")
            return FsMetrics()
        }

        val fields = parseKv(summary)

        return FsMetrics(
            baseline = fields["baseline"]?.toInt() ?: 0,
            truncated = fields["truncated"]?.toInt() ?: 0,
            filesScanned = fields["files"]?.toInt() ?: 0,
            totalEvents = fields["events"]?.toInt() ?: 0,
            createCount = fields["create"]?.toInt() ?: 0,
            modifyCount = fields["modify"]?.toInt() ?: 0,
            deleteCount = fields["delete"]?.toInt() ?: 0,
            suspiciousExtCount = fields["suspicious"]?.toInt() ?: 0,
            lockedExtCount = fields["locked"]?.toInt() ?: 0,
            copyLikeCount = fields["copy"]?.toInt() ?: 0,
            encryptLikeCount = fields["encrypt"]?.toInt() ?: 0,
            sourceOnlyCount = fields["source"]?.toInt() ?: 0,
            totalBytesChanged = fields["bytes"] ?: 0L,
            uniqueDirsTouched = fields["dirs"]?.toInt() ?: 0,
            uniqueExtTouched = fields["exts"]?.toInt() ?: 0,
        )
    }

    private fun collectFdMatches(
        svc: com.colourswift.cssecurity.ISystemWatcherService,
    ): List<FdMatch> {
        val out = try {
            svc.fdSnapshot()
        } catch (t: Throwable) {
            Log.d("SystemWatcher", "FD_SNAPSHOT_ERR err=${t.javaClass.simpleName}:${t.message}")
            return emptyList()
        }

        if (out.isBlank()) {
            return emptyList()
        }

        val matches = mutableListOf<FdMatch>()

        for (line in out.lines()) {
            val parts = line.split('|')
            if (parts.size < 3) continue

            val pid = parts[0].toIntOrNull() ?: continue
            val uid = parts[1].toIntOrNull() ?: continue
            val path = parts[2]

            matches.add(FdMatch(pid, uid, path))

            if (matches.size <= 10) {
                Log.d("SystemWatcher", "FD_MATCH pid=$pid uid=$uid path=$path")
            }
        }

        return matches
    }

    private fun selectFsAttribution(
        frames: List<ProcessFrame>,
        metrics: FsMetrics,
        fdScores: Map<Int, Int>,
        activeUids: Set<Int>,
        nowMs: Long,
    ): FsAttribution {
        if (metrics.totalEvents == 0) return FsAttribution("none")

        val sticky = stickyFsOwner
        if (sticky != null) {
            val (stickyUid, stickyTs) = sticky
            if (activeUids.contains(stickyUid) && nowMs - stickyTs <= 10_000L) {
                val stickyFrame = frames.firstOrNull { it.uid == stickyUid }
                if (stickyFrame != null) {
                    stickyFsOwner = Pair(stickyUid, nowMs)
                    Log.d(
                        "SystemWatcher",
                        "FS_OWNER mode=sticky uid=$stickyUid pkg=${stickyFrame.pkg} pid=${stickyFrame.pid} ageMs=${nowMs - stickyTs} events=${metrics.totalEvents} encrypt=${metrics.encryptLikeCount} locked=${metrics.lockedExtCount}"
                    )
                    return FsAttribution("inferred", stickyUid)
                }
            } else {
                stickyFsOwner = null
            }
        }

        val fdOwner = frames
            .filter { frame -> isAttributionCandidate(frame) && (fdScores[frame.uid] ?: 0) > 0 }
            .maxWithOrNull(
                compareBy<ProcessFrame> { fdScores[it.uid] ?: 0 }
                    .thenBy { it.deltaCpu }
            )

        if (fdOwner != null) {
            stickyFsOwner = Pair(fdOwner.uid, nowMs)
            Log.d(
                "SystemWatcher",
                "FS_OWNER mode=fd uid=${fdOwner.uid} pkg=${fdOwner.pkg} pid=${fdOwner.pid} deltaCpu=${fdOwner.deltaCpu} fdScore=${fdScores[fdOwner.uid] ?: 0} events=${metrics.totalEvents} encrypt=${metrics.encryptLikeCount} locked=${metrics.lockedExtCount} suspicious=${metrics.suspiciousExtCount}"
            )
            return FsAttribution("fd", fdOwner.uid)
        }

        val minCpu = minimumCpuForFs(metrics)
        val isDangerous = metrics.encryptLikeCount > 0 || metrics.suspiciousExtCount > 0 || metrics.lockedExtCount > 0

        if (isDangerous && topCpuFsHistory.size >= 3) {
            val freq = topCpuFsHistory.groupingBy { it }.eachCount()
            val histEntry = freq.entries.maxByOrNull { it.value }
            if (histEntry != null && histEntry.value >= 3) {
                val histUid = histEntry.key
                if (activeUids.contains(histUid)) {
                    val histFrame = frames.firstOrNull { frame ->
                        frame.uid == histUid && isAttributionCandidate(frame) && frame.deltaCpu >= minCpu
                    }
                    if (histFrame != null) {
                        stickyFsOwner = Pair(histUid, nowMs)
                        Log.d(
                            "SystemWatcher",
                            "FS_OWNER mode=history uid=$histUid pkg=${histFrame.pkg} pid=${histFrame.pid} histFreq=${histEntry.value} deltaCpu=${histFrame.deltaCpu} events=${metrics.totalEvents} encrypt=${metrics.encryptLikeCount} locked=${metrics.lockedExtCount}"
                        )
                        return FsAttribution("inferred", histUid)
                    }
                }
            }
        }

        val candidates = frames
            .filter { frame -> isAttributionCandidate(frame) && frame.deltaCpu >= minCpu }
            .sortedByDescending { it.deltaCpu }

        val top = candidates.getOrNull(0)
        val second = candidates.getOrNull(1)

        if (top != null) {
            val secondCpu = second?.deltaCpu ?: 0L
            val clearOwner = top.deltaCpu >= (secondCpu * 3L + 20L)
            val absoluteOk = !isDangerous || top.deltaCpu >= DANGEROUS_FS_MIN_CPU

            if (clearOwner && absoluteOk) {
                stickyFsOwner = Pair(top.uid, nowMs)
                Log.d(
                    "SystemWatcher",
                    "FS_OWNER mode=inferred uid=${top.uid} pkg=${top.pkg} pid=${top.pid} deltaCpu=${top.deltaCpu} secondCpu=$secondCpu events=${metrics.totalEvents} encrypt=${metrics.encryptLikeCount} locked=${metrics.lockedExtCount} suspicious=${metrics.suspiciousExtCount}"
                )
                return FsAttribution("inferred", top.uid)
            }

            if (clearOwner) {
                Log.d(
                    "SystemWatcher",
                    "FS_INFERRED_REJECTED uid=${top.uid} pkg=${top.pkg} deltaCpu=${top.deltaCpu} below DANGEROUS_FS_MIN_CPU=$DANGEROUS_FS_MIN_CPU events=${metrics.totalEvents} encrypt=${metrics.encryptLikeCount}"
                )
            }
        }

        val broadcastCandidates = frames.filter { frame ->
            isAttributionCandidate(frame) && frame.deltaCpu >= minCpu
        }

        if (broadcastCandidates.isEmpty()) {
            Log.d(
                "SystemWatcher",
                "FS_ATTRIB_NONE no candidates above minCpu=$minCpu events=${metrics.totalEvents}"
            )
            return FsAttribution("none")
        }

        return FsAttribution("broadcast")
    }

    private fun minimumCpuForFs(metrics: FsMetrics): Long {
        return when {
            metrics.encryptLikeCount > 0 || metrics.suspiciousExtCount > 0 -> 10L
            metrics.deleteCount >= 25 && metrics.createCount >= 25 -> 25L
            metrics.copyLikeCount > 0 -> 35L
            else -> 60L
        }
    }

    private fun isAttributionCandidate(frame: ProcessFrame): Boolean {
        return !frame.isSystem &&
                frame.pkg != context.packageName &&
                frame.uid >= 10000 &&
                !isIgnoredAttributionPackage(frame.pkg)
    }

    private fun isIgnoredAttributionPackage(pkg: String): Boolean {
        val lower = pkg.lowercase(Locale.US)

        return lower == "logd" ||
                lower == "lmkd" ||
                lower == "statsd" ||
                lower == "artd" ||
                lower == "wificond" ||
                lower.contains("google.android.gms") ||
                lower.contains("google.android.apps.photos") ||
                lower.contains("google.android.apps.nbu.files") ||
                lower.contains("android.hardware") ||
                lower.contains("samsung.hardware")
    }

    private fun isSystemPackage(pm: PackageManager, pkg: String): Boolean {
        return try {
            val ai = pm.getApplicationInfo(pkg, 0)
            (ai.flags and ApplicationInfo.FLAG_SYSTEM) != 0
        } catch (_: Throwable) {
            false
        }
    }

    private fun forceStop(pid: Int, pkg: String) {
        val svc = service ?: return

        try {
            val result = svc.shExit("am force-stop $pkg")

            if (result != 0) {
                svc.shExit("kill -9 $pid")
            }
        } catch (_: Throwable) {
            try {
                svc.shExit("kill -9 $pid")
            } catch (_: Throwable) {
            }
        }
    }

    private fun parseKv(s: String): Map<String, Long> {
        val out = mutableMapOf<String, Long>()

        for (pair in s.split(';')) {
            val split = pair.split('=')
            if (split.size < 2) continue

            val key = split[0]
            val value = split[1].toLongOrNull() ?: 0L

            out[key] = value
        }

        return out
    }

    private data class PkgInfo(
        val name: String,
        val hasFg: Boolean,
        val hasComp: Boolean,
    )

    private fun resolvePackage(pm: PackageManager, uid: Int, procName: String): PkgInfo {
        return try {
            val pkgs = pm.getPackagesForUid(uid)
            val pkg = pkgs?.firstOrNull() ?: procName
            val pi = pm.getPackageInfo(pkg, PackageManager.GET_SERVICES)
            val hasFg = pi.services?.any { it.isForeground() } ?: false

            PkgInfo(pkg, hasFg, hasComp = true)
        } catch (_: Throwable) {
            PkgInfo(procName, hasFg = false, hasComp = false)
        }
    }
}

private fun timestamp(): String =
    SimpleDateFormat("HH:mm:ss", Locale.US).format(Date())

private fun android.content.pm.ServiceInfo.isForeground(): Boolean =
    foregroundServiceType != 0