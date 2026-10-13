package com.colourswift.cssecurity.vpn.backend_port.health

import java.util.concurrent.Executors
import java.util.concurrent.ScheduledExecutorService
import java.util.concurrent.ScheduledFuture
import java.util.concurrent.TimeUnit
import java.util.concurrent.atomic.AtomicBoolean

class ReconnectScheduler(
    private val shouldContinue: () -> Boolean,
    private val hasConnectivity: () -> Boolean,
    private val currentGeneration: () -> Int,
    private val onAttempt: (Int) -> Unit,
    private val onWaitingForNetwork: () -> Unit,
    private val log: (String) -> Unit
) {

    companion object {
        val BACKOFFS_MS = longArrayOf(2000, 5000, 10000, 20000, 30000)
    }

    private val scheduler: ScheduledExecutorService =
        Executors.newSingleThreadScheduledExecutor { r ->
            Thread(r, "cs-vpn-reconnect").apply { isDaemon = true }
        }

    private val inFlight = AtomicBoolean(false)
    private var pending: ScheduledFuture<*>? = null

    @Volatile
    var reconnecting: Boolean = false
        private set

    @Volatile
    var attempt: Int = 0
        private set

    fun enter(reason: String) {
        if (!shouldContinue()) return
        if (reconnecting) return

        reconnecting = true
        log("enter_reconnecting reason=$reason")
        schedule()
    }

    fun reset() {
        cancelPending()
        reconnecting = false
        attempt = 0
        inFlight.set(false)
    }

    fun onConnectivityRegained() {
        if (!reconnecting) return
        attempt = 0
        log("connectivity_regained")
        schedule()
    }

    fun schedule() {
        cancelPending()
        if (!shouldContinue() || !reconnecting) return

        if (!hasConnectivity()) {
            onWaitingForNetwork()
            return
        }

        val idx = attempt.coerceIn(0, BACKOFFS_MS.size - 1)
        val delay = BACKOFFS_MS[idx]
        val gen = currentGeneration()

        pending = try {
            scheduler.schedule({ runAttempt(gen) }, delay, TimeUnit.MILLISECONDS)
        } catch (_: Throwable) {
            null
        }
    }

    private fun runAttempt(gen: Int) {
        if (!shouldContinue() || !reconnecting) return
        if (gen != currentGeneration()) return
        if (!inFlight.compareAndSet(false, true)) return

        try {
            if (!hasConnectivity()) {
                schedule()
                return
            }

            attempt += 1
            log("reconnect_attempt n=$attempt")
            onAttempt(gen)
        } catch (t: Throwable) {
            log("reconnect_attempt_error err=${t.message ?: "unknown"}")
        } finally {
            inFlight.set(false)
        }
    }

    private fun cancelPending() {
        try {
            pending?.cancel(false)
        } catch (_: Throwable) {
        }
        pending = null
    }

    fun shutdown() {
        reset()
        try {
            scheduler.shutdownNow()
        } catch (_: Throwable) {
        }
    }
}
