package com.colourswift.cssecurity.vpn.backend_port.storage

import android.content.Context
import android.util.Base64
import com.wireguard.crypto.KeyPair
import java.io.File
import java.security.SecureRandom

object VpnIdentityStore {

    private const val ANON_KEY_PATH =
        "/storage/emulated/0/Documents/avarionx/deviceKey/devicekey.txt"

    data class Keypair(val privateB64: String, val publicB64: String)

    fun getOrCreateDeviceId(ctx: Context): String {
        val existing = VpnPrefsStore.deviceId(ctx)
        if (existing.isNotEmpty()) return existing

        val now = System.currentTimeMillis()
        val bytes = ByteArray(24) { i -> ((now + i * 997L) and 0xff).toByte() }
        val encoded = Base64.encodeToString(bytes, Base64.URL_SAFE or Base64.NO_WRAP)
        val id = "android_$encoded"
        VpnPrefsStore.setDeviceId(ctx, id)
        return id
    }

    fun getOrCreateAnonymousDeviceKey(ctx: Context): String {
        try {
            val file = File(ANON_KEY_PATH)
            if (file.exists()) {
                val existing = file.readText().trim()
                if (existing.isNotEmpty()) return existing
            }

            val created = randomOpaqueId()
            file.parentFile?.mkdirs()
            file.writeText(created)

            val saved = file.readText().trim()
            if (saved.isNotEmpty()) return saved
        } catch (_: Throwable) {
        }

        val existing = VpnPrefsStore.anonDeviceKeyFallback(ctx)
        if (existing.isNotEmpty()) return existing

        val created = randomOpaqueId()
        VpnPrefsStore.setAnonDeviceKeyFallback(ctx, created)
        return created
    }

    fun getOrCreateKeypair(ctx: Context): Keypair {
        val priv = VpnPrefsStore.wgPrivateKey(ctx)
        val pub = VpnPrefsStore.wgPublicKey(ctx)
        if (priv.isNotEmpty() && pub.isNotEmpty()) return Keypair(priv, pub)

        val kp = KeyPair()
        val privB64 = kp.privateKey.toBase64()
        val pubB64 = kp.publicKey.toBase64()
        VpnPrefsStore.setWgKeypair(ctx, privB64, pubB64)
        return Keypair(privB64, pubB64)
    }

    private fun randomOpaqueId(): String {
        val bytes = ByteArray(32)
        SecureRandom().nextBytes(bytes)
        return Base64.encodeToString(
            bytes,
            Base64.URL_SAFE or Base64.NO_WRAP or Base64.NO_PADDING
        )
    }
}
