package com.colourswift.cssecurity.rtp

import com.colourswift.cssecurity.ISystemWatcherService
import java.io.BufferedReader
import java.io.File
import java.io.InputStreamReader
import java.util.ArrayDeque
import java.util.concurrent.ConcurrentHashMap

class SystemWatcherUserService : ISystemWatcherService.Stub() {

    private data class FileState(
        val size: Long,
        val modified: Long,
    )

    private data class ScanSummary(
        var baseline: Int = 0,
        var truncated: Int = 0,
        var files: Int = 0,
        var events: Int = 0,
        var create: Int = 0,
        var modify: Int = 0,
        var delete: Int = 0,
        var suspicious: Int = 0,
        var locked: Int = 0,
        var copyLike: Int = 0,
        var encryptLike: Int = 0,
        var sourceOnly: Int = 0,
        var bytes: Long = 0L,
        val dirs: MutableSet<String> = mutableSetOf(),
        val exts: MutableSet<String> = mutableSetOf(),
    )

    private val rootStates = ConcurrentHashMap<String, MutableMap<String, FileState>>()

    // Extensions seen at baseline per root — used to detect uniform new extensions
    private val rootBaselineExts = ConcurrentHashMap<String, Set<String>>()

    companion object {
        // How many files must share the same new unknown extension to flag as suspicious
        private const val NEW_EXT_UNIFORM_THRESHOLD = 5
    }

    override fun ps(): String {
        val p = ProcessBuilder("sh", "-c", "ps -A -o PID,UID,NAME")
            .redirectErrorStream(true)
            .start()

        val out = StringBuilder()

        BufferedReader(InputStreamReader(p.inputStream)).use { r ->
            while (true) {
                out.append(r.readLine() ?: break).append('\n')
            }
        }

        p.waitFor()
        return out.toString()
    }

    override fun proc(pid: Int): String {
        val cmd = buildString {
            append("IO=$(cat /proc/$pid/io 2>/dev/null); ")
            append("STAT=$(cat /proc/$pid/stat 2>/dev/null); ")
            append("STATUS=$(cat /proc/$pid/status 2>/dev/null); ")
            append("printf '%s\\n---\\n%s\\n---\\n%s' \"\$IO\" \"\$STAT\" \"\$STATUS\"")
        }

        val p = ProcessBuilder("sh", "-c", cmd)
            .redirectErrorStream(true)
            .start()

        val out = StringBuilder()

        BufferedReader(InputStreamReader(p.inputStream)).use { r ->
            while (true) {
                out.append(r.readLine() ?: break).append('\n')
            }
        }

        p.waitFor()
        return out.toString()
    }

    override fun procParsed(pid: Int): String {
        var writeBytes = 0L
        var syscw = 0L
        var utime = 0L
        var stime = 0L
        var threads = 0
        var vmRssKb = 0L

        var ioOk = 1
        var statOk = 1
        var statusOk = 1
        var ioErr = ""
        var statErr = ""
        var statusErr = ""

        try {
            File("/proc/$pid/io").forEachLine { line ->
                val split = line.split(':')
                if (split.size < 2) return@forEachLine

                val key = split[0].trim()
                val value = split[1].trim().toLongOrNull() ?: 0L

                when (key) {
                    "write_bytes" -> writeBytes = value
                    "syscw" -> syscw = value
                }
            }
        } catch (t: Throwable) {
            ioOk = 0
            ioErr = t.javaClass.simpleName
        }

        try {
            val stat = File("/proc/$pid/stat").readText().trim()
            val parts = stat.substringAfter(')').trim().split(' ')

            if (parts.size >= 18) {
                utime = parts[11].toLongOrNull() ?: 0L
                stime = parts[12].toLongOrNull() ?: 0L
                threads = parts[17].toIntOrNull() ?: 0
            }
        } catch (t: Throwable) {
            statOk = 0
            statErr = t.javaClass.simpleName
        }

        try {
            File("/proc/$pid/status").forEachLine { line ->
                if (line.startsWith("VmRSS:")) {
                    vmRssKb = line.split("\\s+".toRegex())
                        .getOrNull(1)
                        ?.toLongOrNull() ?: 0L
                }
            }
        } catch (t: Throwable) {
            statusOk = 0
            statusErr = t.javaClass.simpleName
        }

        return "wb=$writeBytes;syscw=$syscw;utime=$utime;stime=$stime;thr=$threads;rss=$vmRssKb;ioOk=$ioOk;statOk=$statOk;statusOk=$statusOk;ioErr=$ioErr;statErr=$statErr;statusErr=$statusErr"
    }

    override fun externalSnapshot(root: String, maxFiles: Int): String {
        val base = File(root)

        if (!base.exists()) {
            return "baseline=0;truncated=0;files=0;events=0;create=0;modify=0;delete=0;suspicious=0;locked=0;copy=0;encrypt=0;source=0;bytes=0;dirs=0;exts=0"
        }

        val previous = rootStates.getOrPut(root) { ConcurrentHashMap() }
        val current = HashMap<String, FileState>()
        val seen = HashSet<String>()
        val summary = ScanSummary()
        val queue = ArrayDeque<File>()

        // Track new/modified file extensions this cycle for uniformity detection
        // ext → count of new/modified files bearing it
        val newExtCounts = HashMap<String, Int>()

        // Collect all extensions during baseline walk
        val baselineExtCollector = if (previous.isEmpty()) HashSet<String>() else null

        queue.add(base)

        while (queue.isNotEmpty() && summary.files < maxFiles) {
            val dir = queue.removeFirst()

            val files = try {
                dir.listFiles()
            } catch (_: Throwable) {
                null
            } ?: continue

            for (file in files) {
                if (summary.files >= maxFiles) {
                    summary.truncated = 1
                    break
                }

                try {
                    val path = file.absolutePath
                    val lower = path.lowercase()

                    if (file.isDirectory) {
                        if (shouldEnterDirectory(lower)) {
                            queue.add(file)
                        }
                    } else if (file.isFile && shouldTrackPath(lower)) {
                        val size = file.length()
                        val modified = file.lastModified()
                        val state = FileState(size, modified)
                        val old = previous[path]

                        current[path] = state
                        seen.add(path)
                        summary.files++

                        // Collect extensions during baseline pass
                        baselineExtCollector?.let { collector ->
                            val ext = lower.substringAfterLast('.', missingDelimiterValue = "")
                            if (ext.isNotBlank() && ext.length <= 12) collector.add(ext)
                        }

                        if (previous.isNotEmpty()) {
                            val isNew = old == null
                            val isModified = !isNew && (old!!.size != size || old.modified != modified)

                            if (isNew || isModified) {
                                recordEvent(summary, path, size, isDelete = false, isCreate = isNew)

                                // Track ext for uniformity check — only for non-baseline scans
                                val ext = lower.substringAfterLast('.', missingDelimiterValue = "")
                                if (ext.isNotBlank() && ext.length <= 12) {
                                    newExtCounts[ext] = (newExtCounts[ext] ?: 0) + 1
                                }
                            }
                        }
                    }
                } catch (_: Throwable) {
                }
            }
        }

        if (previous.isEmpty()) {
            previous.clear()
            previous.putAll(current)
            // Save baseline extensions for this root
            rootBaselineExts[root] = baselineExtCollector ?: emptySet()
            summary.baseline = 1
            return encodeSummary(summary)
        }

        if (summary.truncated == 0) {
            for ((path, _) in previous) {
                if (!seen.contains(path) && shouldTrackPath(path.lowercase())) {
                    recordEvent(summary, path, 0L, isDelete = true, isCreate = false)
                }
            }
        }

        // Uniformity check: any new unknown extension appearing on >= threshold files
        // is suspicious regardless of what the extension name is
        val baselineExts = rootBaselineExts[root] ?: emptySet()
        for ((ext, count) in newExtCounts) {
            if (count >= NEW_EXT_UNIFORM_THRESHOLD && !baselineExts.contains(ext)) {
                // Each file with this unknown uniform extension counts as suspicious
                summary.suspicious += count
            }
        }

        previous.clear()
        previous.putAll(current)

        return encodeSummary(summary)
    }

    override fun fdSnapshot(): String {
        val proc = File("/proc")
        val out = StringBuilder()

        val pids = try {
            proc.listFiles()
        } catch (_: Throwable) {
            null
        } ?: return ""

        for (pidDir in pids) {
            val pid = pidDir.name.toIntOrNull() ?: continue
            val uid = readUid(pidDir) ?: continue
            val fdDir = File(pidDir, "fd")

            val fds = try {
                fdDir.listFiles()
            } catch (_: Throwable) {
                null
            } ?: continue

            for (fd in fds) {
                try {
                    val target = fd.canonicalPath

                    if (
                        target.startsWith("/storage/emulated/0/") ||
                        target.startsWith("/sdcard/")
                    ) {
                        out.append(pid)
                            .append('|')
                            .append(uid)
                            .append('|')
                            .append(target)
                            .append('\n')
                    }
                } catch (_: Throwable) {
                }
            }
        }

        return out.toString()
    }

    override fun shExit(cmd: String): Int {
        val p = ProcessBuilder("sh", "-c", cmd)
            .redirectErrorStream(true)
            .start()

        BufferedReader(InputStreamReader(p.inputStream)).use { r ->
            while (true) {
                r.readLine() ?: break
            }
        }

        return try {
            p.waitFor()
        } catch (_: Throwable) {
            -1
        }
    }

    override fun shOut(cmd: String): String {
        val p = ProcessBuilder("sh", "-c", cmd)
            .redirectErrorStream(true)
            .start()

        val out = StringBuilder()

        BufferedReader(InputStreamReader(p.inputStream)).use { r ->
            while (true) {
                out.append(r.readLine() ?: break).append('\n')
            }
        }

        p.waitFor()
        return out.toString()
    }

    override fun destroy() {
        System.exit(0)
    }

    private fun recordEvent(
        summary: ScanSummary,
        path: String,
        size: Long,
        isDelete: Boolean,
        isCreate: Boolean,
    ) {
        val lower = path.lowercase()
        summary.events++

        if (isDelete) {
            summary.delete++
        } else if (isCreate) {
            summary.create++
        } else {
            summary.modify++
        }

        val dir = lower.substringBeforeLast('/', missingDelimiterValue = "")
        if (dir.isNotBlank()) {
            summary.dirs.add(dir)
        }

        val ext = lower.substringAfterLast('.', missingDelimiterValue = "")
        if (ext.isNotBlank() && ext.length <= 12) {
            summary.exts.add(ext)
        }

        if (!isDelete) {
            if (isSuspiciousExt(lower)) {
                summary.suspicious++
            }

            if (lower.endsWith(".locked")) {
                summary.locked++
            }

            if (lower.contains("/copied/")) {
                summary.copyLike++
            }

            if (lower.contains("/encrypted/") || isSuspiciousExt(lower)) {
                summary.encryptLike++
            }

            if (lower.contains("/source/")) {
                summary.sourceOnly++
            }

            summary.bytes += size.coerceAtLeast(0L)
        }
    }

    private fun encodeSummary(summary: ScanSummary): String {
        return "baseline=${summary.baseline};truncated=${summary.truncated};files=${summary.files};events=${summary.events};create=${summary.create};modify=${summary.modify};delete=${summary.delete};suspicious=${summary.suspicious};locked=${summary.locked};copy=${summary.copyLike};encrypt=${summary.encryptLike};source=${summary.sourceOnly};bytes=${summary.bytes};dirs=${summary.dirs.size};exts=${summary.exts.size}"
    }

    private fun shouldEnterDirectory(path: String): Boolean {
        if (path.contains("/.thumbnails")) return false
        if (path.contains("/android/data")) return false
        if (path.contains("/android/obb")) return false
        if (path.contains("/cache")) return false
        return true
    }

    private fun shouldTrackPath(path: String): Boolean {
        if (!path.startsWith("/storage/emulated/0/")) return false
        if (path.contains("/.thumbnails/")) return false
        if (path.contains("/android/data/")) return false
        if (path.contains("/android/obb/")) return false
        if (path.contains("/cache/")) return false
        return true
    }

    private fun isSuspiciousExt(path: String): Boolean {
        return path.endsWith(".locked") ||
                path.endsWith(".encrypted") ||
                path.endsWith(".enc") ||
                path.endsWith(".crypt") ||
                path.endsWith(".vxlock") ||
                path.endsWith(".ransom")
    }

    private fun readUid(pidDir: File): Int? {
        return try {
            var result: Int? = null

            File(pidDir, "status").forEachLine { line ->
                if (line.startsWith("Uid:")) {
                    result = line.split("\\s+".toRegex())
                        .getOrNull(1)
                        ?.toIntOrNull()
                }
            }

            result
        } catch (_: Throwable) {
            null
        }
    }
}