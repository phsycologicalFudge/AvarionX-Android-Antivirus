package com.colourswift.cssecurity.vpn.backend_port.health

import java.net.HttpURLConnection
import java.net.InetAddress
import java.net.InetSocketAddress
import java.net.Socket
import java.net.URL

object TunnelProbe {

    const val PROBE_URL = "https://cp.cloudflare.com/generate_204"

    private const val DNS_TIMEOUT_MS = 4000
    private const val CONNECT_TIMEOUT_MS = 8000
    private const val READ_TIMEOUT_MS = 8000
    private const val LATENCY_HOST = "1.1.1.1"
    private const val LATENCY_PORT = 53
    private const val LATENCY_TIMEOUT_MS = 4000

    data class ProbeResult(
        val ok: Boolean,
        val statusCode: Int,
        val elapsedMs: Long,
        val error: String?
    )

    fun probe(
        url: String = PROBE_URL,
        dnsTimeoutMs: Int = DNS_TIMEOUT_MS,
        connectTimeoutMs: Int = CONNECT_TIMEOUT_MS,
        readTimeoutMs: Int = READ_TIMEOUT_MS
    ): ProbeResult {
        val started = System.currentTimeMillis()
        var conn: HttpURLConnection? = null

        return try {
            val uri = URL(url)
            val host = uri.host
            if (host.isNullOrEmpty()) {
                return ProbeResult(false, 0, 0, "empty host")
            }

            if (!resolves(host, dnsTimeoutMs)) {
                return ProbeResult(
                    false,
                    0,
                    System.currentTimeMillis() - started,
                    "dns failure"
                )
            }

            conn = (uri.openConnection() as HttpURLConnection).apply {
                requestMethod = "GET"
                connectTimeout = connectTimeoutMs
                readTimeout = readTimeoutMs
                instanceFollowRedirects = false
            }

            val code = conn.responseCode
            try {
                conn.inputStream?.use { it.readBytes() }
            } catch (_: Throwable) {
                try {
                    conn.errorStream?.use { it.readBytes() }
                } catch (_: Throwable) {
                }
            }

            ProbeResult(true, code, System.currentTimeMillis() - started, null)
        } catch (t: Throwable) {
            ProbeResult(
                false,
                0,
                System.currentTimeMillis() - started,
                t.message ?: t.javaClass.simpleName
            )
        } finally {
            try {
                conn?.disconnect()
            } catch (_: Throwable) {
            }
        }
    }

    private fun resolves(host: String, dnsTimeoutMs: Int): Boolean {
        val resolved = java.util.concurrent.atomic.AtomicBoolean(false)

        val t = Thread {
            try {
                resolved.set(InetAddress.getAllByName(host).isNotEmpty())
            } catch (_: Throwable) {
                resolved.set(false)
            }
        }

        return try {
            t.isDaemon = true
            t.start()
            t.join(dnsTimeoutMs.toLong())
            if (t.isAlive) {
                t.interrupt()
                false
            } else {
                resolved.get()
            }
        } catch (_: Throwable) {
            false
        }
    }

    fun measureLatencyMs(): Int? {
        var socket: Socket? = null
        return try {
            val started = System.nanoTime()
            socket = Socket()
            socket.connect(InetSocketAddress(LATENCY_HOST, LATENCY_PORT), LATENCY_TIMEOUT_MS)
            ((System.nanoTime() - started) / 1_000_000L).toInt()
        } catch (_: Throwable) {
            null
        } finally {
            try {
                socket?.close()
            } catch (_: Throwable) {
            }
        }
    }
}