package com.colourswift.cssecurity

import com.colourswift.cssecurity.vpn.backend_port.core.VpnConnectionController
import com.colourswift.cssecurity.vpn.backend_port.core.VpnPlanResolver
import com.colourswift.cssecurity.vpn.backend_port.core.VpnStateObserver
import com.colourswift.cssecurity.vpn.backend_port.core.VpnStatusSnapshot
import com.colourswift.cssecurity.vpn.backend_port.storage.VpnPrefsStore
import io.flutter.plugin.common.EventChannel

object CsVpnStatusEvents : VpnStateObserver {

    private val lock = Any()
    private val sinks = LinkedHashSet<EventChannel.EventSink>()
    private val mainHandler = android.os.Handler(android.os.Looper.getMainLooper())

    @Volatile
    private var last: Map<String, Any?>? = null

    fun addSink(s: EventChannel.EventSink?) {
        if (s == null) return

        val snapshot: Map<String, Any?>?
        synchronized(lock) {
            sinks.add(s)
            snapshot = last
        }

        if (snapshot != null) {
            try {
                s.success(snapshot)
            } catch (_: Exception) {
            }
        }
    }

    fun removeSink(s: EventChannel.EventSink?) {
        if (s == null) return
        synchronized(lock) {
            sinks.remove(s)
        }
    }

    fun toMap(snapshot: VpnStatusSnapshot): Map<String, Any?> {
        return mapOf(
            "state" to snapshot.state.name.lowercase(),
            "transport" to snapshot.transport.wire,
            "region" to snapshot.region,
            "wantsConnected" to snapshot.wantsConnected,
            "pausedByUser" to snapshot.pausedByUser,
            "reconnectAttempt" to snapshot.reconnectAttempt,
            "lastHandshakeMs" to snapshot.lastHandshakeMs,
            "rxBytes" to snapshot.rxBytes,
            "txBytes" to snapshot.txBytes,
            "detail" to snapshot.detail,
            "downloadBps" to VpnConnectionController.downloadBytesPerSecond(),
            "uploadBps" to VpnConnectionController.uploadBytesPerSecond(),
            "latencyMs" to VpnConnectionController.latencyMillis(),
            "expectedIp" to snapshot.expectedIp
        )
    }

    override fun onVpnStatus(snapshot: VpnStatusSnapshot) {
        val map = toMap(snapshot)
        val targets: List<EventChannel.EventSink>

        synchronized(lock) {
            last = map
            targets = sinks.toList()
        }

        if (targets.isEmpty()) return

        mainHandler.post {
            for (t in targets) {
                try {
                    t.success(map)
                } catch (_: Exception) {
                }
            }
        }
    }
}
