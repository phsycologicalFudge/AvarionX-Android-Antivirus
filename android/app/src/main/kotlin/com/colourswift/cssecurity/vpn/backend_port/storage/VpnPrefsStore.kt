package com.colourswift.cssecurity.vpn.backend_port.storage

import android.content.Context

object VpnPrefsStore {

    const val K_AUTH_TOKEN = "cs_auth_token"
    const val K_WG_PRIV = "cs_wg_private_key_b64"
    const val K_WG_PUB = "cs_wg_public_key_b64"
    const val K_DEVICE_ID = "cs_device_id"
    const val K_VPN_MODE = "cs_vpn_mode"
    const val K_VPN_TRANSPORT = "cs_vpn_transport"
    const val K_WG_CONFIG_LAST = "cs_wg_config_last"
    const val K_SELECTED_SERVER_ID = "cs_vpn_selected_region"
    const val K_ANON_DEVICE_KEY_FALLBACK = "cs_anonymous_device_key_fallback"
    const val K_SPLIT_EXCLUDED_PKGS = "cs_vpn_split_excluded_pkgs"

    private const val K_PLAN_REGION = "cs_port_last_region"
    private const val K_PLAN_TRANSPORT = "cs_port_last_transport"
    private const val K_PLAN_PREMIUM = "cs_port_last_premium"
    private const val K_WANTS_CONNECTED = "cs_port_wants_connected"
    private const val K_PAUSED_BY_USER = "cs_port_paused_by_user"
    private const val K_PEER_CACHE = "cs_port_peer_cache"
    private const val K_PEER_CACHE_REGION = "cs_port_peer_cache_region"
    private const val K_PEER_CACHE_AT = "cs_port_peer_cache_at"

    fun authToken(ctx: Context): String = FlutterPrefsBridge.getString(ctx, K_AUTH_TOKEN)

    fun deviceId(ctx: Context): String = FlutterPrefsBridge.getString(ctx, K_DEVICE_ID)

    fun setDeviceId(ctx: Context, value: String) =
        FlutterPrefsBridge.putString(ctx, K_DEVICE_ID, value)

    fun anonDeviceKeyFallback(ctx: Context): String =
        FlutterPrefsBridge.getString(ctx, K_ANON_DEVICE_KEY_FALLBACK)

    fun setAnonDeviceKeyFallback(ctx: Context, value: String) =
        FlutterPrefsBridge.putString(ctx, K_ANON_DEVICE_KEY_FALLBACK, value)

    fun wgPrivateKey(ctx: Context): String = FlutterPrefsBridge.getString(ctx, K_WG_PRIV)

    fun wgPublicKey(ctx: Context): String = FlutterPrefsBridge.getString(ctx, K_WG_PUB)

    fun setWgKeypair(ctx: Context, privB64: String, pubB64: String) {
        FlutterPrefsBridge.putString(ctx, K_WG_PRIV, privB64)
        FlutterPrefsBridge.putString(ctx, K_WG_PUB, pubB64)
    }

    fun selectedServerId(ctx: Context): String =
        FlutterPrefsBridge.getString(ctx, K_SELECTED_SERVER_ID, "de")

    fun storedTransport(ctx: Context): String =
        FlutterPrefsBridge.getString(ctx, K_VPN_TRANSPORT, "wireguard").lowercase()

    fun excludedPackages(ctx: Context): List<String> =
        FlutterPrefsBridge.getStringList(ctx, K_SPLIT_EXCLUDED_PKGS)

    fun setLastWgConfig(ctx: Context, cfg: String) =
        FlutterPrefsBridge.putString(ctx, K_WG_CONFIG_LAST, cfg)

    fun setVpnModeFull(ctx: Context) {
        FlutterPrefsBridge.putString(ctx, K_VPN_MODE, "full")
    }

    fun setVpnModeOff(ctx: Context) {
        FlutterPrefsBridge.putString(ctx, K_VPN_MODE, "off")
    }

    fun savePlan(ctx: Context, region: String, transport: String, premium: Boolean) {
        FlutterPrefsBridge.putString(ctx, K_PLAN_REGION, region)
        FlutterPrefsBridge.putString(ctx, K_PLAN_TRANSPORT, transport)
        FlutterPrefsBridge.putBool(ctx, K_PLAN_PREMIUM, premium)
    }

    fun planRegion(ctx: Context): String = FlutterPrefsBridge.getString(ctx, K_PLAN_REGION)

    fun planTransport(ctx: Context): String =
        FlutterPrefsBridge.getString(ctx, K_PLAN_TRANSPORT, "wireguard").lowercase()

    fun planPremium(ctx: Context): Boolean = FlutterPrefsBridge.getBool(ctx, K_PLAN_PREMIUM, false)

    fun wantsConnected(ctx: Context): Boolean =
        FlutterPrefsBridge.getBool(ctx, K_WANTS_CONNECTED, false)

    fun setWantsConnected(ctx: Context, value: Boolean) =
        FlutterPrefsBridge.putBool(ctx, K_WANTS_CONNECTED, value)

    fun pausedByUser(ctx: Context): Boolean =
        FlutterPrefsBridge.getBool(ctx, K_PAUSED_BY_USER, false)

    fun setPausedByUser(ctx: Context, value: Boolean) =
        FlutterPrefsBridge.putBool(ctx, K_PAUSED_BY_USER, value)

    fun cachedPeer(ctx: Context): String = FlutterPrefsBridge.getString(ctx, K_PEER_CACHE)

    fun cachedPeerRegion(ctx: Context): String =
        FlutterPrefsBridge.getString(ctx, K_PEER_CACHE_REGION)

    fun cachedPeerAtMs(ctx: Context): Long =
        FlutterPrefsBridge.getString(ctx, K_PEER_CACHE_AT).toLongOrNull() ?: 0L

    fun setCachedPeer(ctx: Context, json: String, region: String) {
        FlutterPrefsBridge.putString(ctx, K_PEER_CACHE, json)
        FlutterPrefsBridge.putString(ctx, K_PEER_CACHE_REGION, region)
        FlutterPrefsBridge.putString(ctx, K_PEER_CACHE_AT, System.currentTimeMillis().toString())
    }

    fun clearCachedPeer(ctx: Context) {
        FlutterPrefsBridge.remove(ctx, K_PEER_CACHE)
        FlutterPrefsBridge.remove(ctx, K_PEER_CACHE_REGION)
        FlutterPrefsBridge.remove(ctx, K_PEER_CACHE_AT)
    }
}