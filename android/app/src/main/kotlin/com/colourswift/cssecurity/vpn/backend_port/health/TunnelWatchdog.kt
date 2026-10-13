package com.colourswift.cssecurity.vpn.backend_port.health

import com.colourswift.cssecurity.vpn.backend_port.core.VpnTransport
import com.colourswift.cssecurity.vpn.wireguard.CSWireGuardService
import java.util.concurrent.Executors
import java.util.concurrent.ScheduledExecutorService
import java.util.concurrent.TimeUnit
import java.util.concurrent.atomic.AtomicBoolean

data class TunnelObservation(
    val running: Boolean,
    val runningTransport: VpnTransport?,
    val statsAvailable: Boolean,
    val rxBytes: Long,
    val txBytes: Long,
    val lastHandshakeMs: Long,
    val observedAtMs: Long
)

class TunnelWatchdog(
    private val onObservation: (TunnelObservation) -> Unit,
    private val log: (String) -> Unit
) {

    companion object {
        const val TICK_INTERVAL_MS = 1000L
        private const val EARLIEST_SANE_EPOCH_MS = 1577836800000L

        fun normaliseHandshakeEpochMs(raw: Long): Long {
            if (raw <= 0L) return 0L

            val candidate = when {
                raw < 100000000000L -> raw * 1000L
                raw > 100000000000000000L -> raw / 1000000L
                raw > 100000000000000L -> raw / 1000L
                else -> raw
            }

            val latestSane = System.currentTimeMillis() + 5 * 60 * 1000L
            if (candidate < EARLIEST_SANE_EPOCH_MS || candidate > latestSane) return 0L
            return candidate
        }

        fun runningTransport(): VpnTransport? {
            return when {
                CSWireGuardService.isRunning -> VpnTransport.WIREGUARD
                else -> null
            }
        }
    }

    private val running = AtomicBoolean(false)
    private var scheduler: ScheduledExecutorService? = null

    fun start() {
        if (!running.compareAndSet(false, true)) return

        scheduler = Executors.newSingleThreadScheduledExecutor { r ->
            Thread(r, "cs-vpn-watchdog").apply { isDaemon = true }
        }.also { sched ->
            sched.scheduleWithFixedDelay(
                { tick() },
                TICK_INTERVAL_MS,
                TICK_INTERVAL_MS,
                TimeUnit.MILLISECONDS
            )
        }
    }

    fun stop() {
        if (!running.compareAndSet(true, false)) return
        try {
            scheduler?.shutdownNow()
        } catch (_: Throwable) {
        }
        scheduler = null
    }

    private fun tick() {
        try {
            val transport = runningTransport()
            val isUp = transport != null

            val stats = when (transport) {
                VpnTransport.WIREGUARD -> CSWireGuardService.snapshotStats()
                else -> null
            }

            val observation = TunnelObservation(
                running = isUp,
                runningTransport = transport,
                statsAvailable = stats != null,
                rxBytes = stats?.get("rxBytes") ?: 0L,
                txBytes = stats?.get("txBytes") ?: 0L,
                lastHandshakeMs = normaliseHandshakeEpochMs(stats?.get("lastHandshake") ?: 0L),
                observedAtMs = System.currentTimeMillis()
            )

            onObservation(observation)
        } catch (t: Throwable) {
            log("watchdog_tick_error err=${t.message ?: "unknown"}")
        }
    }
}
