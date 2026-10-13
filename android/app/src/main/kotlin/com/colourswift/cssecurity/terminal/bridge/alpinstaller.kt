package com.colourswift.cssecurity.terminal.bridge

import android.content.Context
import android.os.Build
import android.system.Os
import android.util.Log
import org.apache.commons.compress.archivers.tar.TarArchiveInputStream
import java.io.File
import java.io.InputStream
import java.util.zip.GZIPInputStream

object AlpineInstaller {

    private const val TAG = "AlpineInstaller"
    private const val VERSION = 1
    private const val PREFS = "alpine_prefs"
    private const val KEY_VERSION = "installed_version"

    // Asset paths (must match pubspec.yaml)
    private const val ASSET_ALPINE_ARM64 = "flutter_assets/assets/linux/alpine-arm64.tar.gz"
    private const val ASSET_ALPINE_ARM32 = "flutter_assets/assets/linux/alpine-arm32.tar.gz"

    val alpineDir: File get() = File(_filesDir, "alpine")

    fun prootFile(context: Context): File =
        File(context.applicationInfo.nativeLibraryDir, "libproot.so")

    private lateinit var _filesDir: File

    // ─── Public API ────────────────────────────────────────────────────────────

    fun isInstalled(context: Context): Boolean {
        _filesDir = context.filesDir
        val prefs = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
        if (prefs.getInt(KEY_VERSION, 0) < VERSION) return false
        return prootFile(context).exists() && File(alpineDir, "etc/alpine-release").exists()
    }

    /**
     * Install proot + Alpine from bundled assets.
     * Must be called from a background thread.
     * [onProgress] is invoked with terminal-ready strings (CRLF terminated).
     */
    fun install(context: Context, onProgress: (String) -> Unit) {
        _filesDir = context.filesDir

        val isArm64 = isArm64()
        val alpineAsset = if (isArm64) ASSET_ALPINE_ARM64 else ASSET_ALPINE_ARM32
        val abi = if (isArm64) "arm64" else "arm32"

        Log.i(TAG, "Installing Alpine for $abi  proot=${prootFile(context).absolutePath}")

        if (!prootFile(context).exists()) {
            emit(onProgress, "\r\n[ERROR] libproot.so not found in nativeLibraryDir\r\n")
            throw IllegalStateException("libproot.so missing from nativeLibraryDir")
        }

        try {
            emit(onProgress, "  → Extracting Alpine Linux rootfs (this may take a moment)...")
            extractAlpine(context, alpineAsset)
            emit(onProgress, "  ✓ Alpine rootfs extracted")

            emit(onProgress, "  → Configuring...")
            configure()
            emit(onProgress, "  ✓ Configured")

            context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
                .edit().putInt(KEY_VERSION, VERSION).apply()

            emit(onProgress, "\r\nAlpine Linux ready. Restarting terminal...\r\n")

        } catch (e: Exception) {
            Log.e(TAG, "Install failed", e)
            emit(onProgress, "\r\n[ERROR] Install failed: ${e.message}\r\n")
            alpineDir.deleteRecursively()
            throw e
        }
    }

    // ─── Private helpers ───────────────────────────────────────────────────────

    private fun extractAlpine(context: Context, assetPath: String) {
        if (alpineDir.exists()) alpineDir.deleteRecursively()
        alpineDir.mkdirs()

        openAsset(context, assetPath).use { raw ->
            TarArchiveInputStream(GZIPInputStream(raw)).use { tar ->
                var entry = tar.nextTarEntry
                while (entry != null) {
                    val name = entry.name.trimStart('/', '.')
                        .trimStart('/')
                    if (name.isNotEmpty()) {
                        val target = File(alpineDir, name)
                        when {
                            entry.isDirectory -> target.mkdirs()
                            entry.isSymbolicLink -> {
                                target.parentFile?.mkdirs()
                                target.delete()
                                try {
                                    Os.symlink(entry.linkName, target.absolutePath)
                                } catch (e: Exception) {
                                    Log.w(TAG, "symlink failed ${target.absolutePath} -> ${entry.linkName}: ${e.message}")
                                }
                            }
                            entry.isLink -> {
                                val linkTarget = File(alpineDir, entry.linkName.trimStart('/', '.').trimStart('/'))
                                target.parentFile?.mkdirs()
                                target.delete()
                                if (linkTarget.exists()) {
                                    linkTarget.copyTo(target, overwrite = true)
                                    if (entry.mode and 0b001_001_001 != 0) target.setExecutable(true, false)
                                } else {
                                    Log.w(TAG, "hard link target missing: ${entry.linkName}")
                                }
                            }
                            entry.isFile -> {
                                target.parentFile?.mkdirs()
                                target.outputStream().use { out -> tar.copyTo(out) }
                                if (entry.mode and 0b001_001_001 != 0) {
                                    target.setExecutable(true, false)
                                }
                            }
                        }
                    }
                    entry = tar.nextTarEntry
                }
            }
        }
        Log.i(TAG, "Alpine extracted to ${alpineDir.absolutePath}")
    }

    private fun configure() {
        val resolv = File(alpineDir, "etc/resolv.conf")
        resolv.parentFile?.mkdirs()
        resolv.writeText("nameserver 8.8.8.8\nnameserver 8.8.4.4\n")

        File(alpineDir, "root").mkdirs()

        val tmp = File(alpineDir, "tmp")
        tmp.mkdirs()
        tmp.setWritable(true, false)
        tmp.setExecutable(true, false)

        val profileD = File(alpineDir, "etc/profile.d/ax.sh")
        profileD.parentFile?.mkdirs()
        profileD.writeText("export PS1='\\u@alpine:\\w\\$ '\n")
    }

    private fun openAsset(context: Context, path: String): InputStream =
        context.assets.open(path)

    private fun emit(onProgress: (String) -> Unit, msg: String) =
        onProgress("$msg\r\n")

    private fun isArm64(): Boolean {
        val primary = Build.SUPPORTED_ABIS.firstOrNull() ?: ""
        return primary == "arm64-v8a"
    }
}