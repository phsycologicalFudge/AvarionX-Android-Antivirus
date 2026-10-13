package com.colourswift.cssecurity.terminal.bridge

import android.content.Context
import android.system.Os
import android.util.Log
import java.io.File

object BusyboxInstaller {
    // CRITICAL: Bumped to 3 to force the installer to run again
    private const val VERSION = 3
    private const val PREFS = "busybox_prefs"
    private const val KEY_VERSION = "installed_version"

    private val SYMLINKS = listOf(
        "sh", "ash", "ls", "cat", "cp", "mv", "rm", "mkdir", "rmdir", "chmod", "chown",
        "ln", "find", "stat", "touch", "du", "df", "dd", "grep", "egrep", "fgrep", "sed", "awk",
        "ps", "kill", "top", "free", "ping", "netstat", "ifconfig", "ip", "wget", "nc",
        "head", "tail", "wc", "sort", "uniq", "cut", "tr", "xargs", "tar", "gzip", "gunzip",
        "bzip2", "bunzip2", "echo", "printf", "test", "date", "uptime", "uname", "hexdump", "od",
        "env", "which", "whoami", "id", "diff", "cmp", "base64", "md5sum", "sha256sum",
        "tree", "less", "more", "curl"
    )

    val binDir: File get() = File(_filesDir, "bin")
    val homeDir: File get() = File(_filesDir, "home")

    private lateinit var _filesDir: File

    fun install(context: Context) {
        _filesDir = context.filesDir

        val prefs = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
        val installedVersion = prefs.getInt(KEY_VERSION, 0)

        Log.e("BusyboxInstaller", "Checking install. Current Version: $VERSION, Installed Version: $installedVersion")

        if (installedVersion >= VERSION) {
            // File.exists() follows symlinks, so a broken symlink returns false even though
            // the filesystem entry is still there. Use lstat via Os.stat to check the link
            // itself, not its target.
            val shLink = File(binDir, "sh")
            val shLinkValid = try {
                Os.lstat(shLink.absolutePath) // throws if the path doesn't exist at all
                shLink.exists()               // true only if the target also exists
            } catch (_: Exception) {
                false
            }
            if (shLinkValid) {
                Log.e("BusyboxInstaller", "Already installed and verified. Returning.")
                return
            }
            Log.e("BusyboxInstaller", "Symlinks missing or broken despite version match. Forcing reinstall.")
            // Clear the saved version so we don't loop back here if install fails mid-way
            prefs.edit().remove(KEY_VERSION).apply()
        }

        binDir.mkdirs()
        homeDir.mkdirs()

        val nativeLibDir = context.applicationInfo.nativeLibraryDir
        val nativeBusyboxPath = "$nativeLibDir/libbusybox.so"

        val busyboxBin = File(nativeBusyboxPath)
        Log.e("BusyboxInstaller", "Native Busybox path: $nativeBusyboxPath")
        Log.e("BusyboxInstaller", "Native Busybox exists: ${busyboxBin.exists()}")

        if (!busyboxBin.exists()) {
            throw IllegalStateException("Native Busybox not found at $nativeBusyboxPath.")
        }

        createSymlinks(busyboxBin.absolutePath)
        prefs.edit().putInt(KEY_VERSION, VERSION).apply()
        Log.e("BusyboxInstaller", "Installation complete.")
    }

    private fun createSymlinks(targetBinaryPath: String) {
        Log.e("BusyboxInstaller", "Creating symlinks in ${binDir.absolutePath}")
        var successCount = 0

        SYMLINKS.forEach { cmd ->
            val link = File(binDir, cmd)

            // File.exists() follows symlinks — a broken symlink (pointing to an old native
            // lib that no longer exists) returns false, so the old `if (exists) delete()`
            // guard was silently skipping the delete, leaving the stale inode in place and
            // causing Os.symlink to throw EEXIST.  Os.remove() operates on the link itself
            // regardless of whether its target is live, so it reliably clears both cases.
            try { Os.remove(link.absolutePath) } catch (_: Exception) { /* didn't exist, fine */ }

            try {
                Os.symlink(targetBinaryPath, link.absolutePath)
                successCount++
            } catch (e: Exception) {
                Log.e("BusyboxInstaller", "Failed to create symlink for $cmd", e)
            }
        }
        Log.e("BusyboxInstaller", "Successfully created $successCount / ${SYMLINKS.size} symlinks.")

        // Final verification
        val shLink = File(binDir, "sh")
        Log.e("BusyboxInstaller", "VERIFICATION: Does 'sh' exist now? ${shLink.exists()}")
    }
}