package com.colourswift.cssecurity.vpn

object DnsPacketUtils {

    fun isIpv4Udp(d: ByteArray): Boolean {
        if (d.size < 28) return false
        val v = (d[0].toInt() ushr 4) and 0xF
        if (v != 4) return false
        return (d[9].toInt() and 0xFF) == 17
    }

    fun ipHeaderLength(d: ByteArray): Int {
        return (d[0].toInt() and 0x0F) * 4
    }

    fun isDnsToFakeServer(d: ByteArray, fakeDnsIp: String): Boolean {
        val ihl = ipHeaderLength(d)
        if (d.size < ihl + 8) return false

        val dstIp = ((d[16].toInt() and 0xFF) shl 24) or
                ((d[17].toInt() and 0xFF) shl 16) or
                ((d[18].toInt() and 0xFF) shl 8) or
                (d[19].toInt() and 0xFF)

        val parts = fakeDnsIp.split(".").map { it.toInt() }
        val fakeInt = (parts[0] shl 24) or (parts[1] shl 16) or (parts[2] shl 8) or parts[3]

        val dstPort = ((d[ihl + 2].toInt() and 0xFF) shl 8) or (d[ihl + 3].toInt() and 0xFF)
        return dstIp == fakeInt && dstPort == 53
    }

    fun extractDnsPayload(d: ByteArray): ByteArray? {
        val ihl = ipHeaderLength(d)
        if (d.size < ihl + 8 + 12) return null

        val totalLen = ((d[2].toInt() and 0xFF) shl 8) or (d[3].toInt() and 0xFF)
        val udpLen = ((d[ihl + 4].toInt() and 0xFF) shl 8) or (d[ihl + 5].toInt() and 0xFF)
        if (totalLen < ihl + udpLen) return null

        val dnsStart = ihl + 8
        val dnsLen = udpLen - 8
        if (dnsStart + dnsLen > d.size) return null

        return d.copyOfRange(dnsStart, dnsStart + dnsLen)
    }

    fun extractDomain(d: ByteArray): String? {
        val dnsPayload = extractDnsPayload(d) ?: return null
        if (dnsPayload.size < 12) return null

        var off = 12
        val labels = ArrayList<String>()

        while (off < dnsPayload.size) {
            val len = dnsPayload[off].toInt() and 0xFF
            if (len == 0) break
            if ((len and 0xC0) == 0xC0) break
            if (off + 1 + len > dnsPayload.size) return null

            labels.add(String(dnsPayload, off + 1, len, Charsets.US_ASCII))
            off += 1 + len
        }

        if (labels.isEmpty()) return null
        var t = labels.joinToString(".").trim().lowercase()
        if (t.endsWith(".")) t = t.dropLast(1)
        if (t.startsWith("www.")) t = t.substring(4)
        return t
    }

    fun rebuildDnsReply(original: ByteArray, dnsReply: ByteArray): ByteArray {
        val ihl = ipHeaderLength(original)
        val udpOff = ihl

        val clientIp = original.copyOfRange(12, 16)
        val fakeIp = original.copyOfRange(16, 20)

        val clientPort = (((original[udpOff].toInt() and 0xFF) shl 8)
                or (original[udpOff + 1].toInt() and 0xFF))

        val serverPort = (((original[udpOff + 2].toInt() and 0xFF) shl 8)
                or (original[udpOff + 3].toInt() and 0xFF))

        val totalLen = ihl + 8 + dnsReply.size
        val out = ByteArray(totalLen)

        System.arraycopy(original, 0, out, 0, ihl)

        out[2] = ((totalLen shr 8) and 0xFF).toByte()
        out[3] = (totalLen and 0xFF).toByte()

        out[12] = fakeIp[0]
        out[13] = fakeIp[1]
        out[14] = fakeIp[2]
        out[15] = fakeIp[3]

        out[16] = clientIp[0]
        out[17] = clientIp[1]
        out[18] = clientIp[2]
        out[19] = clientIp[3]

        out[udpOff] = (serverPort shr 8).toByte()
        out[udpOff + 1] = (serverPort and 0xFF).toByte()

        out[udpOff + 2] = (clientPort shr 8).toByte()
        out[udpOff + 3] = (clientPort and 0xFF).toByte()

        val udpLen = 8 + dnsReply.size
        out[udpOff + 4] = ((udpLen shr 8) and 0xFF).toByte()
        out[udpOff + 5] = (udpLen and 0xFF).toByte()

        out[udpOff + 6] = 0
        out[udpOff + 7] = 0

        val dnsStart = ihl + 8
        System.arraycopy(dnsReply, 0, out, dnsStart, dnsReply.size)

        out[10] = 0
        out[11] = 0
        val ipSum = ipv4Checksum(out, 0, ihl)
        out[10] = ((ipSum shr 8) and 0xFF).toByte()
        out[11] = (ipSum and 0xFF).toByte()

        val udpSum = udpChecksum(out, udpOff, udpLen)
        out[udpOff + 6] = ((udpSum shr 8) and 0xFF).toByte()
        out[udpOff + 7] = (udpSum and 0xFF).toByte()

        return out
    }

    fun ipv4Checksum(d: ByteArray, off: Int, len: Int): Int {
        var sum = 0L
        var i = 0
        while (i < len) {
            val w = ((d[off + i].toInt() and 0xFF) shl 8) or (d[off + i + 1].toInt() and 0xFF)
            sum += w
            i += 2
        }
        while (sum shr 16 != 0L) sum = (sum and 0xFFFF) + (sum shr 16)
        return (sum.inv() and 0xFFFF).toInt()
    }

    fun udpChecksum(d: ByteArray, udpOff: Int, udpLen: Int): Int {
        val src = ((d[12].toInt() and 0xFF) shl 24) or
                ((d[13].toInt() and 0xFF) shl 16) or
                ((d[14].toInt() and 0xFF) shl 8) or
                (d[15].toInt() and 0xFF)

        val dst = ((d[16].toInt() and 0xFF) shl 24) or
                ((d[17].toInt() and 0xFF) shl 16) or
                ((d[18].toInt() and 0xFF) shl 8) or
                (d[19].toInt() and 0xFF)

        var sum = 0L
        sum += (src shr 16) and 0xFFFF
        sum += src and 0xFFFF
        sum += (dst shr 16) and 0xFFFF
        sum += dst and 0xFFFF
        sum += 17
        sum += udpLen.toLong()

        var i = 0
        while (i < udpLen) {
            val b1 = d[udpOff + i].toInt() and 0xFF
            val b2 = if (i + 1 < udpLen) d[udpOff + i + 1].toInt() and 0xFF else 0
            sum += ((b1 shl 8) or b2)
            i += 2
        }

        while (sum shr 16 != 0L) sum = (sum and 0xFFFF) + (sum shr 16)
        val out = (sum.inv() and 0xFFFF).toInt()
        return if (out == 0) 0xFFFF else out
    }

    fun buildNxDomain(query: ByteArray): ByteArray? {
        if (query.size < 12) return null
        val out = query.copyOf()

        out[2] = (out[2].toInt() or 0x80).toByte()
        out[3] = ((out[3].toInt() and 0xF0) or 0x03).toByte()

        out[6] = 0
        out[7] = 0
        out[8] = 0
        out[9] = 0
        out[10] = 0
        out[11] = 0

        return out
    }
}
