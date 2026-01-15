package com.colourswift.cssecurity

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

    override fun destroy() {
        System.exit(0)
    }
}
