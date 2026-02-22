package com.colourswift.cssecurity.rtp

import com.colourswift.cssecurity.ISystemWatcherService
import java.io.BufferedReader
import java.io.InputStreamReader

class SystemWatcherUserService : ISystemWatcherService.Stub() {

    override fun ps(): String {
        val p = ProcessBuilder("sh", "-c", "ps -A -o PID,UID,NAME").redirectErrorStream(true).start()
        val out = StringBuilder()
        BufferedReader(InputStreamReader(p.inputStream)).use { r ->
            while (true) {
                val line = r.readLine() ?: break
                out.append(line).append('\n')
            }
        }
        p.waitFor()
        return out.toString()
    }

    override fun proc(pid: Int): String {
        val cmd = buildString {
            append("IO=$(cat /proc/")
            append(pid)
            append("/io 2>/dev/null); ")
            append("STAT=$(cat /proc/")
            append(pid)
            append("/stat 2>/dev/null); ")
            append("STATUS=$(cat /proc/")
            append(pid)
            append("/status 2>/dev/null); ")
            append("printf '%s\\n---\\n%s\\n---\\n%s' \"\$IO\" \"\$STAT\" \"\$STATUS\"")
        }
        val p = ProcessBuilder("sh", "-c", cmd).redirectErrorStream(true).start()
        val out = StringBuilder()
        BufferedReader(InputStreamReader(p.inputStream)).use { r ->
            while (true) {
                val line = r.readLine() ?: break
                out.append(line).append('\n')
            }
        }
        p.waitFor()
        return out.toString()
    }

    override fun shExit(cmd: String): Int {
        val p = ProcessBuilder("sh", "-c", cmd).redirectErrorStream(true).start()
        BufferedReader(InputStreamReader(p.inputStream)).use { r ->
            while (true) {
                val line = r.readLine() ?: break
            }
        }
        return try { p.waitFor() } catch (_: Throwable) { -1 }
    }

    override fun shOut(cmd: String): String {
        val p = ProcessBuilder("sh", "-c", cmd).redirectErrorStream(true).start()
        val out = StringBuilder()
        BufferedReader(InputStreamReader(p.inputStream)).use { r ->
            while (true) {
                val line = r.readLine() ?: break
                out.append(line).append('\n')
            }
        }
        p.waitFor()
        return out.toString()
    }

    override fun destroy() {
        System.exit(0)
    }
}