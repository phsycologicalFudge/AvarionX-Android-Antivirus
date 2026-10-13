package com.colourswift.cssecurity.terminal.bridge

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.os.ParcelFileDescriptor
import android.system.ErrnoException
import android.system.Os
import android.system.OsConstants
import android.util.Log
import com.colourswift.cssecurity.ISystemWatcherService
import com.colourswift.cssecurity.terminal.emulator.TermSession
import io.flutter.plugin.common.EventChannel
import java.io.File
import java.io.FileDescriptor
import java.io.FileInputStream
import java.io.FileOutputStream
import java.io.OutputStream

class PtyTermSession(private val context: Context) : TermSession() {

    var shellMode: String = "alpine"
    var eventSink: EventChannel.EventSink? = null

    private val mainHandler   = Handler(Looper.getMainLooper())
    private val nativeLibDir  = context.applicationInfo.nativeLibraryDir
    private val busyboxPath   = "$nativeLibDir/libbusybox.so"
    private val homePath      = BusyboxInstaller.homeDir.absolutePath
    private val cachePath     = context.cacheDir.absolutePath

    private var masterFd  = -1
    private var masterPfd: ParcelFileDescriptor? = null

    private var pipeReadFd:  FileDescriptor? = null
    private var pipeWriteFd: FileDescriptor? = null
    private val pipeLock = Any()

    @Volatile private var spawned       = false
    @Volatile private var mergerRunning = false

    override fun isRunning(): Boolean = spawned

    var shizukuService: ISystemWatcherService? = null

    fun spawn(): Boolean {
        if (spawned) return true
        spawned = true

        val alpineReady = shellMode == "alpine" && AlpineInstaller.isInstalled(context)
        val prootPath   = if (alpineReady) AlpineInstaller.prootFile(context).absolutePath else ""
        val rootfsPath  = if (alpineReady) AlpineInstaller.alpineDir.absolutePath else ""

        val pfd = if (shizukuService != null) tryShizuku(prootPath, rootfsPath)
        else                        tryDirect(prootPath, rootfsPath)

        if (pfd == null) {
            Log.e(TAG, "spawn: PTY execution context failed")
            spawned = false
            return false
        }

        masterPfd = pfd

        val pipeFds  = Os.pipe()
        pipeReadFd   = pipeFds[0]
        pipeWriteFd  = pipeFds[1]

        setTermIn(FileInputStream(pipeReadFd))
        setTermOut(InterceptOutputStream(FileOutputStream(Os.dup(pfd.fileDescriptor))))

        startMergerThread()
        return true
    }

    private fun tryShizuku(prootPath: String, rootfsPath: String): ParcelFileDescriptor? {
        val svc = shizukuService ?: return null

        val shizukuBase  = "/data/local/tmp/ax_alpine"
        val shizukuHome  = "$shizukuBase/root"
        val shizukuCache = "$shizukuBase/cache"

        File(shizukuHome).mkdirs()
        File(shizukuCache).mkdirs()

        val effectiveRootfs = if (rootfsPath.isNotEmpty()) shizukuBase else ""

        return try {
            svc.spawnPty(
                24, 80, busyboxPath, shizukuHome,
                prootPath, effectiveRootfs, shizukuCache, nativeLibDir
            )
        } catch (e: Exception) {
            Log.e(TAG, "Shizuku spawnPty aborted", e)
            null
        }
    }

    private fun tryDirect(prootPath: String, rootfsPath: String): ParcelFileDescriptor? {
        val fd = PtyHelper.openMaster(24, 80)
        if (fd < 0) return null

        val slaveName = PtyHelper.getSlaveName(fd) ?: run {
            PtyHelper.close(fd); return null
        }

        val pid = PtyHelper.spawnShell(
            fd, slaveName, busyboxPath, homePath,
            prootPath, rootfsPath, cachePath, nativeLibDir
        )
        if (pid < 0) { PtyHelper.close(fd); return null }

        return try {
            val pfd = ParcelFileDescriptor.fromFd(fd)
            PtyHelper.close(fd)
            masterFd = pfd.fd
            pfd
        } catch (e: Exception) {
            Log.e(TAG, "fromFd failed", e)
            PtyHelper.close(fd)
            null
        }
    }

    private fun startMergerThread() {
        mergerRunning = true
        Thread {
            val buf     = ByteArray(4096)
            val writeFd = pipeWriteFd ?: return@Thread
            try {
                val ptyFd = masterPfd?.fileDescriptor ?: return@Thread
                while (mergerRunning) {
                    val n = Os.read(ptyFd, buf, 0, buf.size)
                    if (n <= 0) break
                    synchronized(pipeLock) {
                        Os.write(writeFd, buf, 0, n)
                    }
                }
            } catch (e: ErrnoException) {
                if (e.errno != OsConstants.EIO) Log.e(TAG, "Merger read error errno=${e.errno}", e)
                else                             Log.d(TAG, "Shell exited (EIO)")
            } catch (_: Exception) {
            } finally {
                mergerRunning = false
            }
        }.also {
            it.isDaemon = true
            it.name     = "AX-merger"
            it.start()
        }
    }

    fun injectOutput(text: String) {
        val writeFd = pipeWriteFd ?: return
        try {
            val content = if (text.isEmpty()) "\r\n" else "$text\r\n"
            val bytes   = content.toByteArray(Charsets.UTF_8)
            synchronized(pipeLock) {
                Os.write(writeFd, bytes, 0, bytes.size)
            }
        } catch (_: Exception) {}
    }

    override fun updateSize(columns: Int, rows: Int) {
        super.updateSize(columns, rows)
        if (masterFd >= 0) PtyHelper.resize(masterFd, rows, columns)
    }

    override fun finish() {
        super.finish()
        mergerRunning = false
        masterFd      = -1
        masterPfd?.close()
        masterPfd = null
        try { pipeReadFd?.let  { Os.close(it) } } catch (_: Exception) {}
        try { pipeWriteFd?.let { Os.close(it) } } catch (_: Exception) {}
        pipeReadFd  = null
        pipeWriteFd = null
    }

    private inner class InterceptOutputStream(private val pty: FileOutputStream) : OutputStream() {
        private val lineBuffer = StringBuilder()
        private var escState = 0

        override fun write(b: Int) = processByte(b and 0xFF)

        override fun write(b: ByteArray, off: Int, len: Int) {
            for (i in off until off + len) processByte(b[i].toInt() and 0xFF)
        }

        private fun processByte(byte: Int) {
            when (escState) {
                1 -> {
                    pty.write(byte)
                    pty.flush()
                    escState = when (byte) {
                        0x5B -> 2
                        0x5D -> 3
                        else -> 0
                    }
                    return
                }
                2 -> {
                    pty.write(byte)
                    pty.flush()
                    if (byte in 0x40..0x7E) escState = 0
                    return
                }
                3 -> {
                    pty.write(byte)
                    pty.flush()
                    if (byte == 0x07) escState = 0
                    else if (byte == 0x1B) escState = 1
                    return
                }
            }
            when (byte) {
                0x1B -> {
                    escState = 1
                    pty.write(byte)
                    pty.flush()
                }
                0x0D, 0x0A -> {
                    val line = lineBuffer.toString().trim()
                    val lower = line.lowercase()
                    val isAx = lower.startsWith("ax ") || lower == "ax"
                    lineBuffer.clear()
                    if (isAx) {
                        pty.write(0x15)
                        pty.flush()
                        val cmd = line.substring(2).trim()
                        mainHandler.postDelayed({
                            injectOutput("")
                            eventSink?.success("ax_cmd:$cmd")
                        }, 80)
                    } else {
                        pty.write(byte)
                        pty.flush()
                    }
                }
                0x7F, 0x08 -> {
                    if (lineBuffer.isNotEmpty()) lineBuffer.deleteCharAt(lineBuffer.length - 1)
                    pty.write(byte)
                    pty.flush()
                }
                0x15 -> {
                    lineBuffer.clear()
                    pty.write(byte)
                    pty.flush()
                }
                0x03, 0x04, 0x1A -> {
                    lineBuffer.clear()
                    pty.write(byte)
                    pty.flush()
                }
                else -> {
                    if (byte in 0x20..0x7E) lineBuffer.append(byte.toChar())
                    pty.write(byte)
                    pty.flush()
                }
            }
        }

        override fun flush() = pty.flush()
        override fun close() = pty.close()
    }

    companion object {
        private const val TAG = "AXTerminal"
    }
}