package com.colourswift.cssecurity.vpn.backend_port.core

enum class VpnRuntimeState {
    DISCONNECTED,
    CONNECTING,
    CONNECTED,
    RECONNECTING,
    PAUSED,
    DISCONNECTING
}

data class VpnStatusSnapshot(
    val state: VpnRuntimeState,
    val transport: VpnTransport,
    val region: String,
    val wantsConnected: Boolean,
    val pausedByUser: Boolean,
    val reconnectAttempt: Int,
    val lastHandshakeMs: Long,
    val rxBytes: Long,
    val txBytes: Long,
    val detail: String,
    val expectedIp: String
)

interface VpnStateObserver {
    fun onVpnStatus(snapshot: VpnStatusSnapshot)
}