package com.colourswift.cssecurity.vpn.backend_port.network

import android.content.Context
import com.colourswift.cssecurity.vpn.backend_port.storage.VpnPrefsStore
import org.json.JSONObject
import java.net.HttpURLConnection
import java.net.URL

object VpnApiClient {

    const val API_BASE = "https://api.colourswift.com"

    private const val CONNECT_TIMEOUT_MS = 8000
    private const val READ_TIMEOUT_MS = 8000

    sealed class ProvisionResult {
        data class Success(val peer: JSONObject) : ProvisionResult()
        object Unauthorized : ProvisionResult()
        object Forbidden : ProvisionResult()
        data class Failed(val code: Int, val body: String) : ProvisionResult()
        data class Error(val message: String) : ProvisionResult()
    }

    fun provision(
        ctx: Context,
        deviceId: String,
        deviceName: String,
        publicKeyB64: String,
        region: String,
        anonymousDeviceKey: String
    ): ProvisionResult {
        val token = VpnPrefsStore.authToken(ctx)

        val body = JSONObject().apply {
            put("deviceName", deviceName)
            put("publicKey", publicKeyB64)
            put("region", region)
            if (token.isNotEmpty()) {
                put("deviceId", deviceId)
            } else {
                put("anonymousDeviceKey", anonymousDeviceKey)
            }
        }

        var conn: HttpURLConnection? = null
        return try {
            conn = (URL("$API_BASE/vpn/provision").openConnection() as HttpURLConnection).apply {
                requestMethod = "POST"
                connectTimeout = CONNECT_TIMEOUT_MS
                readTimeout = READ_TIMEOUT_MS
                doOutput = true
                setRequestProperty("content-type", "application/json; charset=utf-8")
                if (token.isNotEmpty()) {
                    setRequestProperty("authorization", "Bearer $token")
                }
            }

            conn.outputStream.use { it.write(body.toString().toByteArray(Charsets.UTF_8)) }

            val code = conn.responseCode
            val raw = if (code in 200..299) {
                conn.inputStream.use { it.readBytes() }
            } else {
                conn.errorStream?.use { it.readBytes() } ?: ByteArray(0)
            }
            val text = String(raw, Charsets.UTF_8)

            when {
                code == 200 -> {
                    val peer = JSONObject(text).optJSONObject("peer")
                        ?: return ProvisionResult.Failed(code, "missing peer")
                    ProvisionResult.Success(peer)
                }

                code == 401 && token.isNotEmpty() -> ProvisionResult.Unauthorized
                code == 403 -> ProvisionResult.Forbidden
                else -> ProvisionResult.Failed(code, text.trim())
            }
        } catch (t: Throwable) {
            ProvisionResult.Error(t.message ?: "provision error")
        } finally {
            try {
                conn?.disconnect()
            } catch (_: Throwable) {
            }
        }
    }
}
