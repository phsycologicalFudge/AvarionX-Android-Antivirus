package com.colourswift.cssecurity.vpn.backend_port.core

import android.content.Context
import android.net.VpnService
import android.util.Log
import com.colourswift.cssecurity.vpn.VpnModeSwitcher
import com.colourswift.cssecurity.vpn.backend_port.health.NetworkStateWatcher
import com.colourswift.cssecurity.vpn.backend_port.health.ReconnectScheduler
import com.colourswift.cssecurity.vpn.backend_port.health.TunnelObservation
import com.colourswift.cssecurity.vpn.backend_port.health.TunnelProbe
import com.colourswift.cssecurity.vpn.backend_port.health.TunnelWatchdog
import com.colourswift.cssecurity.vpn.backend_port.network.VpnApiClient
import com.colourswift.cssecurity.vpn.backend_port.network.VpnConfigBuilder
import com.colourswift.cssecurity.vpn.backend_port.storage.VpnIdentityStore
import com.colourswift.cssecurity.vpn.backend_port.storage.VpnPrefsStore
import org.json.JSONArray
import org.json.JSONObject
import java.util.concurrent.CopyOnWriteArrayList
import java.util.concurrent.Executors
import java.util.concurrent.ScheduledExecutorService
import java.util.concurrent.TimeUnit
import java.util.concurrent.atomic.AtomicBoolean
import java.util.concurrent.atomic.AtomicInteger

object VpnConnectionController {

    private const val TAG = "CSVpnPort"

    private const val INITIAL_HEALTH_GRACE_MS = 20_000L
    private const val RECENT_PROBE_SUCCESS_WINDOW_MS = 45_000L
    private const val PROBE_FAILURES_BEFORE_RECONNECT = 3
    private const val STALE_HANDSHAKE_MS = 210_000L
    private const val INTERFACE_NEVER_UP_MS = 9_000L
    private const val PEER_CACHE_TTL_MS_PREMIUM = 60L * 60L * 1000L
    private const val PROBE_INTERVAL_MS = 30_000L
    private const val CONNECT_PROBE_DNS_TIMEOUT_MS = 700
    private const val CONNECT_PROBE_CONNECT_TIMEOUT_MS = 900
    private const val CONNECT_PROBE_READ_TIMEOUT_MS = 900
    private const val PROVISION_ATTEMPTS = 3
    private const val PROVISION_RETRY_DELAY_MS = 2000L

    private var appContext: Context? = null

    private val initialised = AtomicBoolean(false)
    private val connectGeneration = AtomicInteger(0)
    private val busy = AtomicBoolean(false)

    private val observers = CopyOnWriteArrayList<VpnStateObserver>()

    private val worker = Executors.newSingleThreadExecutor { r ->
        Thread(r, "cs-vpn-controller").apply { isDaemon = true }
    }

    private var probeScheduler: ScheduledExecutorService? = null
    private var watchdog: TunnelWatchdog? = null
    private var networkWatcher: NetworkStateWatcher? = null
    private var reconnects: ReconnectScheduler? = null

    @Volatile
    private var runtimeState: VpnRuntimeState = VpnRuntimeState.DISCONNECTED

    @Volatile
    private var activeTransport: VpnTransport = VpnTransport.WIREGUARD

    @Volatile
    private var activeRegion: String = ""
    private var activeExitIp: String = ""

    @Volatile
    private var wantsConnected: Boolean = false

    @Volatile
    private var pausedByUser: Boolean = false

    @Volatile
    private var intentionalStop: Boolean = false

    @Volatile
    private var connectedAtMs: Long = 0L

    @Volatile
    private var connectStartedAtMs: Long = 0L
    private var usedCachedPeer: Boolean = false

    @Volatile
    private var lastHandshakeMs: Long = 0L

    @Volatile
    private var probeFailStreak: Int = 0

    @Volatile
    private var lastProbeSuccessAtMs: Long = 0L

    @Volatile
    private var prevRxBytes: Long = 0L

    @Volatile
    private var prevTxBytes: Long = 0L

    @Volatile
    private var lastStatsAtMs: Long = 0L

    @Volatile
    private var lastRecentTraffic: Boolean = false

    @Volatile
    private var downloadBps: Double = 0.0

    @Volatile
    private var uploadBps: Double = 0.0

    @Volatile
    private var latencyMs: Int = 0

    @Volatile
    private var detail: String = ""

    fun init(context: Context) {
        if (!initialised.compareAndSet(false, true)) return
        val ctx = context.applicationContext
        appContext = ctx

        wantsConnected = VpnPrefsStore.wantsConnected(ctx)
        pausedByUser = VpnPrefsStore.pausedByUser(ctx)
        activeRegion = VpnPrefsStore.planRegion(ctx)
        activeTransport = VpnTransport.fromWire(VpnPrefsStore.planTransport(ctx))

        networkWatcher = NetworkStateWatcher(ctx) { has ->
            onConnectivityChanged(has)
        }.also { it.start() }

        reconnects = ReconnectScheduler(
            shouldContinue = { wantsConnected && !pausedByUser },
            hasConnectivity = { networkWatcher?.hasConnectivity ?: true },
            currentGeneration = { connectGeneration.get() },
            onAttempt = { gen -> runReconnectAttempt(gen) },
            onWaitingForNetwork = {
                detail = "Reconnecting, waiting for network"
                publish()
            },
            log = { msg -> log(msg) }
        )

        watchdog = TunnelWatchdog(
            onObservation = { obs -> onObservation(obs) },
            log = { msg -> log(msg) }
        ).also { it.start() }

        val current = TunnelWatchdog.runningTransport()
        if (current != null && !pausedByUser) {
            activeTransport = current
            markConnected()
        }

        publish()
    }

    fun addObserver(observer: VpnStateObserver) {
        observers.addIfAbsent(observer)
        observer.onVpnStatus(snapshot())
    }

    fun removeObserver(observer: VpnStateObserver) {
        observers.remove(observer)
    }

    fun snapshot(): VpnStatusSnapshot {
        return VpnStatusSnapshot(
            state = runtimeState,
            transport = activeTransport,
            region = activeRegion,
            wantsConnected = wantsConnected,
            pausedByUser = pausedByUser,
            reconnectAttempt = reconnects?.attempt ?: 0,
            lastHandshakeMs = lastHandshakeMs,
            rxBytes = prevRxBytes,
            txBytes = prevTxBytes,
            detail = detail,
            expectedIp = activeExitIp
        )
    }

    fun downloadBytesPerSecond(): Double = downloadBps

    fun uploadBytesPerSecond(): Double = uploadBps

    fun latencyMillis(): Int = latencyMs

    fun connect(premium: Boolean) {
        val ctx = appContext ?: return
        val plan = VpnPlanResolver.resolve(
            selectedServerId = VpnPrefsStore.selectedServerId(ctx),
            storedTransport = VpnPrefsStore.storedTransport(ctx),
            premium = premium
        )
        connect(plan)
    }

    fun connect(plan: ConnectPlan) {
        val ctx = appContext ?: return

        wantsConnected = true
        pausedByUser = false
        VpnPrefsStore.setWantsConnected(ctx, true)
        VpnPrefsStore.setPausedByUser(ctx, false)
        VpnPrefsStore.savePlan(ctx, plan.region, plan.transport.wire, plan.premium)

        val gen = connectGeneration.incrementAndGet()
        reconnects?.reset()

        worker.execute { runConnect(plan, gen, stopFirst = true) }
    }

    fun switchServer(plan: ConnectPlan) = connect(plan)

    fun disconnect() {
        val ctx = appContext ?: return

        wantsConnected = false
        pausedByUser = false
        VpnPrefsStore.setWantsConnected(ctx, false)
        VpnPrefsStore.setPausedByUser(ctx, false)

        connectGeneration.incrementAndGet()
        reconnects?.reset()

        worker.execute {
            runtimeState = VpnRuntimeState.DISCONNECTING
            detail = "Disconnecting"
            publish()

            intentionalStop = true
            stopActiveTunnel()
            VpnPrefsStore.setVpnModeOff(ctx)

            runtimeState = VpnRuntimeState.DISCONNECTED
            connectedAtMs = 0L
            connectStartedAtMs = 0L
            detail = "Disconnected"
            resetHealthCounters()
            stopProbePolling()
            publish()
        }
    }

    fun markPausedByUser() {
        val ctx = appContext ?: return

        pausedByUser = true
        VpnPrefsStore.setPausedByUser(ctx, true)

        connectGeneration.incrementAndGet()
        reconnects?.reset()
        intentionalStop = true

        runtimeState = VpnRuntimeState.PAUSED
        connectedAtMs = 0L
        connectStartedAtMs = 0L
        detail = "Paused"
        resetHealthCounters()
        stopProbePolling()
        publish()
    }

    fun markResumedFromPause() {
        val ctx = appContext ?: return

        pausedByUser = false
        VpnPrefsStore.setPausedByUser(ctx, false)
        connectGeneration.incrementAndGet()
        reconnects?.reset()

        if (wantsConnected && TunnelWatchdog.runningTransport() == null) {
            runtimeState = VpnRuntimeState.CONNECTING
            connectStartedAtMs = System.currentTimeMillis()
        }

        detail = "Resuming"
        publish()
    }

    fun markExternalDisconnect() {
        val ctx = appContext ?: return

        wantsConnected = false
        pausedByUser = false
        VpnPrefsStore.setWantsConnected(ctx, false)
        VpnPrefsStore.setPausedByUser(ctx, false)

        connectGeneration.incrementAndGet()
        reconnects?.reset()
        intentionalStop = true
        VpnPrefsStore.setVpnModeOff(ctx)
    }

    private fun hostOnly(endpoint: String): String {
        val trimmed = endpoint.trim()
        if (trimmed.isEmpty()) return ""
        if (trimmed.startsWith("[")) {
            val closeIdx = trimmed.indexOf(']')
            if (closeIdx > 0) return trimmed.substring(1, closeIdx)
        }
        val idx = trimmed.lastIndexOf(":")
        if (idx <= 0) return trimmed
        return trimmed.substring(0, idx)
    }

    private fun isIpv4Literal(value: String): Boolean {
        val parts = value.trim().split(".")
        if (parts.size != 4) return false
        for (part in parts) {
            if (part.isEmpty() || !part.all { it.isDigit() }) return false
            val n = part.toIntOrNull() ?: return false
            if (n < 0 || n > 255) return false
            if (part.length > 1 && part.startsWith("0")) return false
        }
        return true
    }

    private fun runConnect(plan: ConnectPlan, gen: Int, stopFirst: Boolean) {
        val ctx = appContext ?: return

        if (!busy.compareAndSet(false, true)) {
            log("connect_skipped busy=true")
            return
        }

        try {
            if (isStale(gen)) return

            runtimeState = VpnRuntimeState.CONNECTING
            connectStartedAtMs = System.currentTimeMillis()
            activeTransport = plan.transport
            activeRegion = plan.region
            detail = "Connecting"
            publish()

            if (VpnService.prepare(ctx) != null) {
                failConnect("VPN permission not granted")
                return
            }

            val token = VpnPrefsStore.authToken(ctx)
            val deviceId = if (token.isNotEmpty()) {
                VpnIdentityStore.getOrCreateDeviceId(ctx)
            } else {
                ""
            }
            val anonKey = if (token.isEmpty()) {
                VpnIdentityStore.getOrCreateAnonymousDeviceKey(ctx)
            } else {
                ""
            }

            if (token.isEmpty() && anonKey.isEmpty()) {
                failConnect("Failed to create device key")
                return
            }

            if (isStale(gen)) return

            val keypair = VpnIdentityStore.getOrCreateKeypair(ctx)

            var peer: JSONObject? = null
            var fromCache = false

            val cached = readCachedPeer(ctx, plan.region, plan.premium)
            if (cached != null) {
                peer = cached
                fromCache = true
                log("peer_cache_hit region=${plan.region}")
            }

            for (attempt in 0 until PROVISION_ATTEMPTS) {
                if (peer != null) break

                if (isStale(gen)) return

                when (val res = VpnApiClient.provision(
                    ctx = ctx,
                    deviceId = deviceId,
                    deviceName = "Android",
                    publicKeyB64 = keypair.publicB64,
                    region = plan.region,
                    anonymousDeviceKey = anonKey
                )) {
                    is VpnApiClient.ProvisionResult.Success -> peer = res.peer

                    is VpnApiClient.ProvisionResult.Unauthorized -> {
                        failConnect("Session expired")
                        return
                    }

                    is VpnApiClient.ProvisionResult.Forbidden -> {
                        failConnect("Plan not allowed for this server")
                        return
                    }

                    is VpnApiClient.ProvisionResult.Failed ->
                        log("provision_failed code=${res.code}")

                    is VpnApiClient.ProvisionResult.Error ->
                        log("provision_error msg=${res.message}")
                }

                if (peer != null) break

                if (attempt < PROVISION_ATTEMPTS - 1) {
                    Thread.sleep(PROVISION_RETRY_DELAY_MS)
                }
            }

            val resolvedPeer = peer ?: run {
                failConnect("Unable to connect")
                return
            }

            usedCachedPeer = fromCache

            if (isStale(gen)) return

            if (stopFirst && TunnelWatchdog.runningTransport() != null) {
                intentionalStop = true
                stopActiveTunnel()
            }

            connectedAtMs = 0L
            lastHandshakeMs = 0L
            probeFailStreak = 0

            val excludedJson = JSONArray(VpnPrefsStore.excludedPackages(ctx)).toString()

            val endpoint = VpnConfigBuilder.str(resolvedPeer, "endpoint")
            val assignedIp = VpnConfigBuilder.str(resolvedPeer, "assignedIp")
            val serverPublicKey = VpnConfigBuilder.str(resolvedPeer, "serverPublicKey")
            val allowed = VpnConfigBuilder.strList(resolvedPeer, "allowedIps")
            val dns = VpnConfigBuilder.strList(resolvedPeer, "dns")

            if (assignedIp.isEmpty() || endpoint.isEmpty() ||
                serverPublicKey.isEmpty() || allowed.isEmpty()
            ) {
                if (fromCache) invalidatePeerCache("incomplete_wg_settings")
                failConnect("Provision returned incomplete settings")
                return
            }

            val cfg = VpnConfigBuilder.buildWgConfig(
                privateKeyB64 = keypair.privateB64,
                address = assignedIp,
                serverPublicKeyB64 = serverPublicKey,
                endpoint = endpoint,
                allowedIps = allowed,
                dns = dns
            )

            VpnPrefsStore.setLastWgConfig(ctx, cfg)
            val exitHost = hostOnly(endpoint)
            activeExitIp = if (isIpv4Literal(exitHost)) exitHost else ""

            if (isStale(gen)) return

            log("wg_start region=${plan.region} endpoint=$endpoint cfgLen=${cfg.length}")
            VpnModeSwitcher.switchToWireGuard(ctx, cfg, excludedJson)

            if (!fromCache && plan.premium) {
                VpnPrefsStore.setCachedPeer(ctx, resolvedPeer.toString(), plan.region)
            }

            VpnPrefsStore.setVpnModeFull(ctx)
            connectStartedAtMs = System.currentTimeMillis()
            detail = "Starting ${plan.transport.label}"
            publish()
        } catch (t: Throwable) {
            if (usedCachedPeer) invalidatePeerCache("connect_exception_${t.message ?: "unknown"}")
            failConnect(t.message ?: "connect error")
        } finally {
            busy.set(false)
        }
    }

    private fun runReconnectAttempt(gen: Int) {
        val ctx = appContext ?: return
        if (gen != connectGeneration.get()) return
        if (!wantsConnected || pausedByUser) return

        val plan = ConnectPlan(
            region = VpnPrefsStore.planRegion(ctx).ifEmpty { activeRegion },
            transport = VpnTransport.fromWire(VpnPrefsStore.planTransport(ctx)),
            premium = VpnPrefsStore.planPremium(ctx)
        )

        runtimeState = VpnRuntimeState.RECONNECTING
        detail = "Reconnecting"
        publish()

        intentionalStop = true
        stopActiveTunnel()
        lastHandshakeMs = 0L
        probeFailStreak = 0

        runConnect(plan, gen, stopFirst = false)
    }

    private fun onObservation(obs: TunnelObservation) {
        if (obs.running && obs.runningTransport != null) {
            activeTransport = obs.runningTransport
        }

        if (obs.running && connectedAtMs == 0L) {
            if (pausedByUser) return
            markConnected()
            return
        }

        if (!obs.running && connectedAtMs > 0L) {
            markDisconnected()
            return
        }

        if (!obs.running) {
            handleNeverCameUp()
            return
        }

        if (obs.statsAvailable) {
            updateStats(obs)
            evaluateTunnelHealth(obs)
        }
    }

    private fun updateStats(obs: TunnelObservation) {
        val now = obs.observedAtMs

        if (lastStatsAtMs > 0L) {
            val dt = (now - lastStatsAtMs) / 1000.0
            if (dt > 0) {
                downloadBps = ((obs.rxBytes - prevRxBytes) / dt).coerceAtLeast(0.0)
                uploadBps = ((obs.txBytes - prevTxBytes) / dt).coerceAtLeast(0.0)
            }
        }

        lastRecentTraffic = obs.rxBytes > prevRxBytes || obs.txBytes > prevTxBytes

        prevRxBytes = obs.rxBytes
        prevTxBytes = obs.txBytes
        lastStatsAtMs = now

        if (obs.lastHandshakeMs > 0L) {
            if (lastHandshakeMs <= 0L) {
                log("first_handshake epochMs=${obs.lastHandshakeMs}")
            }
            lastHandshakeMs = obs.lastHandshakeMs
        }
    }

    private fun evaluateTunnelHealth(obs: TunnelObservation) {
        if (runtimeState != VpnRuntimeState.CONNECTED) return
        if (reconnects?.reconnecting == true) return
        if (!wantsConnected || pausedByUser) return

        val now = obs.observedAtMs
        val connectedFor = if (connectedAtMs > 0L) now - connectedAtMs else 0L
        val hasTunnelTraffic = obs.rxBytes > 0L || obs.txBytes > 0L

        if (lastHandshakeMs <= 0L) {
            if (connectedFor >= INITIAL_HEALTH_GRACE_MS && !hasTunnelTraffic) {
                triggerReconnect("initial_handshake_timeout")
            }
            return
        }

        val ageMs = now - lastHandshakeMs
        if (!lastRecentTraffic && ageMs > STALE_HANDSHAKE_MS) {
            triggerReconnect("stale_handshake_${ageMs}ms")
        }
    }

    private fun handleNeverCameUp() {
        if (runtimeState != VpnRuntimeState.CONNECTING) return
        if (busy.get()) return
        if (connectStartedAtMs <= 0L) return

        val ageMs = System.currentTimeMillis() - connectStartedAtMs
        if (ageMs > INTERFACE_NEVER_UP_MS) {
            connectStartedAtMs = 0L
            invalidatePeerCache("interface_never_up")
            triggerReconnect("interface_never_up")
        }
    }

    private fun readCachedPeer(ctx: android.content.Context, region: String, premium: Boolean): JSONObject? {
        if (!premium) return null

        val raw = VpnPrefsStore.cachedPeer(ctx)
        if (raw.isEmpty()) return null
        if (VpnPrefsStore.cachedPeerRegion(ctx) != region) return null

        val ageMs = System.currentTimeMillis() - VpnPrefsStore.cachedPeerAtMs(ctx)
        if (ageMs < 0L || ageMs > PEER_CACHE_TTL_MS_PREMIUM) return null

        return try {
            JSONObject(raw)
        } catch (t: Throwable) {
            null
        }
    }

    private fun invalidatePeerCache(reason: String) {
        if (!usedCachedPeer) return
        val ctx = appContext ?: return
        usedCachedPeer = false
        VpnPrefsStore.clearCachedPeer(ctx)
        log("peer_cache_invalidated reason=" + reason)
    }

    private fun markConnected() {
        val probeStarted = System.currentTimeMillis()
        val probeResult = TunnelProbe.probe(
            dnsTimeoutMs = CONNECT_PROBE_DNS_TIMEOUT_MS,
            connectTimeoutMs = CONNECT_PROBE_CONNECT_TIMEOUT_MS,
            readTimeoutMs = CONNECT_PROBE_READ_TIMEOUT_MS
        )
        log(
            "connect_probe ok=${probeResult.ok} code=${probeResult.statusCode} " +
                    "elapsedMs=${probeResult.elapsedMs} totalBlockedMs=${System.currentTimeMillis() - probeStarted} " +
                    "error=${probeResult.error}"
        )

        connectedAtMs = System.currentTimeMillis()
        connectStartedAtMs = 0L
        intentionalStop = false
        lastHandshakeMs = 0L
        probeFailStreak = 0
        lastProbeSuccessAtMs = if (probeResult.ok) System.currentTimeMillis() else 0L
        prevRxBytes = 0L
        prevTxBytes = 0L
        lastStatsAtMs = 0L
        lastRecentTraffic = false

        if (probeResult.ok) {
            TunnelProbe.measureLatencyMs()?.let { latencyMs = it }
        }

        runtimeState = VpnRuntimeState.CONNECTED
        detail = "Connected"
        reconnects?.reset()
        startProbePolling()
        publish()
    }

    private fun markDisconnected() {
        val wasIntentional = intentionalStop
        intentionalStop = false

        connectedAtMs = 0L
        connectStartedAtMs = 0L
        activeExitIp = ""
        resetHealthCounters()
        stopProbePolling()

        if (pausedByUser) {
            runtimeState = VpnRuntimeState.PAUSED
            detail = "Paused"
            publish()
            return
        }

        if (!wantsConnected) {
            runtimeState = VpnRuntimeState.DISCONNECTED
            detail = "Disconnected"
            publish()
            return
        }

        if (wasIntentional) {
            publish()
            return
        }

        runtimeState = VpnRuntimeState.RECONNECTING
        detail = "Reconnecting"
        publish()
        triggerReconnect("runtime_stopped")
    }

    private fun triggerReconnect(reason: String) {
        if (!wantsConnected || pausedByUser) return
        val scheduler = reconnects ?: return

        if (scheduler.reconnecting) {
            log("reconnect_reschedule reason=$reason")
            scheduler.schedule()
        } else {
            scheduler.enter(reason)
        }
    }

    private fun onConnectivityChanged(has: Boolean) {
        if (!has) return
        if (!wantsConnected || pausedByUser) return

        if (reconnects?.reconnecting == true) {
            reconnects?.onConnectivityRegained()
            return
        }

        if (!isTunnelUp()) {
            triggerReconnect("connectivity_regained")
        }
    }

    private fun startProbePolling() {
        stopProbePolling()
        probeScheduler = Executors.newSingleThreadScheduledExecutor { r ->
            Thread(r, "cs-vpn-probe").apply { isDaemon = true }
        }.also { sched ->
            sched.scheduleWithFixedDelay({
                try {
                    runProbeCycle()
                } catch (t: Throwable) {
                    log("probe_cycle_error err=${t.message ?: "unknown"}")
                }
            }, PROBE_INTERVAL_MS, PROBE_INTERVAL_MS, TimeUnit.MILLISECONDS)
        }
    }

    private fun stopProbePolling() {
        try {
            probeScheduler?.shutdownNow()
        } catch (_: Throwable) {
        }
        probeScheduler = null
    }

    private fun runProbeCycle() {
        if (!isTunnelUp()) return
        if (runtimeState != VpnRuntimeState.CONNECTED) return

        val result = TunnelProbe.probe()
        if (result.ok) {
            probeFailStreak = 0
            lastProbeSuccessAtMs = System.currentTimeMillis()
            TunnelProbe.measureLatencyMs()?.let { latencyMs = it }
            publish()
            return
        }

        onProbeFailure(result.error ?: "unknown")
    }

    private fun onProbeFailure(reason: String) {
        probeFailStreak += 1
        log("probe_fail streak=$probeFailStreak reason=$reason")

        if (runtimeState != VpnRuntimeState.CONNECTED) return
        if (reconnects?.reconnecting == true) return
        if (!wantsConnected || pausedByUser) return

        val now = System.currentTimeMillis()

        if (connectedAtMs > 0L && now - connectedAtMs < INITIAL_HEALTH_GRACE_MS) return
        if (lastProbeSuccessAtMs > 0L &&
            now - lastProbeSuccessAtMs < RECENT_PROBE_SUCCESS_WINDOW_MS
        ) {
            return
        }

        if (probeFailStreak >= PROBE_FAILURES_BEFORE_RECONNECT) {
            triggerReconnect("probe_fail_streak_$probeFailStreak")
        }
    }

    private fun stopActiveTunnel() {
        val ctx = appContext ?: return
        try {
            VpnModeSwitcher.stopWireGuard(ctx)
        } catch (t: Throwable) {
            log("stop_error err=${t.message ?: "unknown"}")
        }
    }

    private fun failConnect(message: String) {
        detail = message
        log("connect_failed msg=$message")
        connectStartedAtMs = 0L
        activeExitIp = ""

        if (wantsConnected && !pausedByUser) {
            runtimeState = VpnRuntimeState.RECONNECTING
            publish()
            triggerReconnect("connect_failed")
            return
        }

        runtimeState = VpnRuntimeState.DISCONNECTED
        publish()
    }

    private fun resetHealthCounters() {
        lastHandshakeMs = 0L
        probeFailStreak = 0
        lastProbeSuccessAtMs = 0L
        prevRxBytes = 0L
        prevTxBytes = 0L
        lastStatsAtMs = 0L
        downloadBps = 0.0
        uploadBps = 0.0
        latencyMs = 0
        lastRecentTraffic = false
    }

    private fun isTunnelUp(): Boolean = TunnelWatchdog.runningTransport() != null

    private fun isStale(gen: Int): Boolean {
        return gen != connectGeneration.get() || !wantsConnected || pausedByUser
    }

    private fun publish() {
        val snap = snapshot()
        for (observer in observers) {
            try {
                observer.onVpnStatus(snap)
            } catch (_: Throwable) {
            }
        }
    }

    private fun log(message: String) {
        Log.i(TAG, message)
    }
}