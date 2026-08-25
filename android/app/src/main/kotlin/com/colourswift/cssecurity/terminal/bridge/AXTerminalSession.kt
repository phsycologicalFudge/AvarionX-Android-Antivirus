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
import io.flutter.plugin.common.EventChannel
import java.io.File

class AXTerminalSession(private val context: Context) {

    private val mainHandler = Handler(Looper.getMainLooper())

    private val busyboxPath: String
    private val homePath: String
    private val binPath: String
    private val cachePath: String
    private val nativeLibDir: String

    private val prootPath: String
    private val rootfsPath: String

    private var masterFd  = -1
    private var masterPfd: ParcelFileDescriptor? = null

    @Volatile private var running = false
    val isRunning get() = running
    @Volatile private var sink: EventChannel.EventSink? = null

    var shizukuService: ISystemWatcherService? = null

    init {
        BusyboxInstaller.install(context)

        nativeLibDir = context.applicationInfo.nativeLibraryDir
        busyboxPath  = "$nativeLibDir/libbusybox.so"
        homePath     = BusyboxInstaller.homeDir.absolutePath
        binPath      = BusyboxInstaller.binDir.absolutePath
        cachePath    = context.cacheDir.absolutePath

        val alpineReady = AlpineInstaller.isInstalled(context)
        prootPath  = if (alpineReady) AlpineInstaller.prootFile(context).absolutePath else ""
        rootfsPath = if (alpineReady) AlpineInstaller.alpineDir.absolutePath else ""

        Log.d(TAG, "busybox=$busyboxPath  exists=${File(busyboxPath).exists()}")
        Log.d(TAG, "alpine mode=$alpineReady  proot=$prootPath  rootfs=$rootfsPath")
        Log.d(TAG, "loader=${nativeLibDir}/libproot-loader.so  exists=${File("$nativeLibDir/libproot-loader.so").exists()}")
    }

    fun attachSink(s: EventChannel.EventSink) { sink = s }
    fun detachSink()                           { sink = null }

    fun start(rows: Int, cols: Int) {
        if (running) return

        masterPfd = tryShizuku(rows, cols) ?: tryDirect(rows, cols) ?: return

        masterFd = masterPfd!!.fd

        running = true
        startReaderThread()
    }

    private fun tryShizuku(rows: Int, cols: Int): ParcelFileDescriptor? {
        val svc = shizukuService ?: return null

        return try {
            val pfd = svc.spawnPty(
                rows, cols,
                busyboxPath, homePath,
                prootPath, rootfsPath,
                cachePath,
                nativeLibDir,
            )
            if (pfd != null) {
                Log.d(TAG, "PTY via Shizuku  mode=${if (prootPath.isNotEmpty()) "alpine" else "busybox"}")
            }
            pfd
        } catch (e: Exception) {
            Log.w(TAG, "Shizuku spawnPty failed (${e.javaClass.simpleName}: ${e.message}) — falling back to direct PTY")
            null
        }
    }

    private fun tryDirect(rows: Int, cols: Int): ParcelFileDescriptor? {
        val fd = PtyHelper.openMaster(rows, cols)
        if (fd < 0) {
            Log.e(TAG, "openMaster failed")
            return null
        }

        val slaveName = PtyHelper.getSlaveName(fd)
        if (slaveName == null) {
            Log.e(TAG, "getSlaveName failed")
            PtyHelper.close(fd)
            return null
        }
        Log.d(TAG, "PTY direct  master=$fd slave=$slaveName")

        val childPid = PtyHelper.spawnShell(
            fd, slaveName,
            busyboxPath, homePath,
            prootPath, rootfsPath,
            cachePath,
            nativeLibDir,
        )
        if (childPid < 0) {
            Log.e(TAG, "spawnShell failed")
            PtyHelper.close(fd)
            return null
        }
        Log.d(TAG, "Shell pid=$childPid  mode=${if (prootPath.isNotEmpty()) "alpine" else "busybox"}")

        masterFd = fd

        return try {
            ParcelFileDescriptor.fromFd(fd)
        } catch (e: Exception) {
            Log.e(TAG, "fromFd failed", e)
            PtyHelper.close(fd)
            null
        }
    }

    private fun startReaderThread() {
        val startSink = sink
        Thread {
            val buf = ByteArray(4096)
            try {
                val fd = masterPfd?.fileDescriptor ?: return@Thread
                while (running) {
                    val n = Os.read(fd, buf, 0, buf.size)
                    if (n <= 0) break
                    val chunk = buf.copyOf(n)
                    mainHandler.post { sink?.success(chunk) }
                }
            } catch (e: ErrnoException) {
                if (e.errno != OsConstants.EIO) Log.e(TAG, "Read error errno=${e.errno}", e)
                else                             Log.d(TAG, "Shell exited (EIO)")
            } catch (_: java.io.InterruptedIOException) {
            } catch (e: Exception) {
                Log.e(TAG, "Read thread died", e)
            } finally {
                running = false
                mainHandler.post {
                    if (sink === startSink) sink?.endOfStream()
                }
            }
        }.also {
            it.isDaemon = true
            it.name = "AXTerminal-reader"
            it.start()
        }
    }

    fun write(data: ByteArray) {
        try {
            val fd = masterPfd?.fileDescriptor
            if (fd != null) Os.write(fd, data, 0, data.size)
        } catch (_: Exception) {}
    }

    fun resize(rows: Int, cols: Int) {
        if (masterFd >= 0) PtyHelper.resize(masterFd, rows, cols)
    }

    fun close() {
        running = false
        try { masterPfd?.close() } catch (_: Exception) {}
        masterPfd = null
        masterFd  = -1
    }

    companion object {
        private const val TAG = "AXTerminal"
    }
}