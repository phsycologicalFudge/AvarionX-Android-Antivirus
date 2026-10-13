package com.colourswift.cssecurity.vpn.backend_port.core

enum class VpnTransport(val wire: String, val label: String) {
    WIREGUARD("wireguard", "WireGuard");

    companion object {
        fun fromWire(value: String?): VpnTransport = WIREGUARD
    }
}

data class ConnectPlan(
    val region: String,
    val transport: VpnTransport,
    val premium: Boolean
)

object VpnPlanResolver {

    private const val FREE_REGION = "de"

    fun serverPrefix(serverId: String): String {
        return serverId.trim().lowercase()
            .split("-")
            .firstOrNull { it.isNotEmpty() }
            .orEmpty()
    }

    fun isAwgServer(serverId: String): Boolean = serverPrefix(serverId) == "awg"

    fun isHysteriaServer(serverId: String): Boolean = serverPrefix(serverId) == "hy"

    fun isLiteServer(serverId: String): Boolean {
        return serverId.isNotBlank() && !isAwgServer(serverId) && !isHysteriaServer(serverId)
    }

    fun resolve(selectedServerId: String, storedTransport: String, premium: Boolean): ConnectPlan {
        if (!premium) {
            return ConnectPlan(
                region = FREE_REGION,
                transport = VpnTransport.WIREGUARD,
                premium = false
            )
        }

        val requested = selectedServerId.trim().lowercase()
        val region = if (isLiteServer(requested)) requested else FREE_REGION

        return ConnectPlan(
            region = region,
            transport = VpnTransport.WIREGUARD,
            premium = true
        )
    }
}
