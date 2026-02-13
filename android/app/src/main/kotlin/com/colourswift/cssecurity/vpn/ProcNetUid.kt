package com.colourswift.cssecurity.vpn

object ProcNetUid {
    fun lookupUdpUid(localPort: Int): Int? {
        val hexPort = localPort.coerceIn(0, 65535).toString(16).uppercase().padStart(4, '0')
        val f = try {
            java.io.File("/proc/net/udp")
        } catch (_: Exception) {
            return null
        }
        val lines = try {
            f.readLines()
        } catch (_: Exception) {
            return null
        }
        for (i in 1 until lines.size) {
            val line = lines[i].trim()
            if (line.isEmpty()) continue
            val parts = line.split(Regex("\\s+"))
            if (parts.size < 8) continue
            val local = parts[1]
            val uidStr = parts[7]
            val idx = local.indexOf(':')
            if (idx <= 0) continue
            val portHex = local.substring(idx + 1).uppercase()
            if (portHex == hexPort) {
                val uid = uidStr.toIntOrNull() ?: return null
                return uid
            }
        }
        return null
    }
}
