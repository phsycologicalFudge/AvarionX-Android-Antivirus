package com.colourswift.cssecurity.vpn.backend_port.storage

import android.content.Context
import android.content.SharedPreferences
import android.util.Base64
import org.json.JSONArray
import java.io.ByteArrayInputStream
import java.io.ObjectInputStream

object FlutterPrefsBridge {

    private const val PREFS_FILE = "FlutterSharedPreferences"
    private const val KEY_PREFIX = "flutter."
    private const val LIST_IDENTIFIER = "VGhpcyBpcyB0aGUgcHJlZml4IGZvciBhIGxpc3Qu"
    private const val DOUBLE_PREFIX = "VGhpcyBpcyB0aGUgcHJlZml4IGZvciBEb3VibGUu"

    fun prefs(ctx: Context): SharedPreferences {
        return ctx.applicationContext.getSharedPreferences(PREFS_FILE, Context.MODE_PRIVATE)
    }

    private fun full(key: String): String {
        return if (key.startsWith(KEY_PREFIX)) key else KEY_PREFIX + key
    }

    fun getString(ctx: Context, key: String, fallback: String = ""): String {
        return try {
            prefs(ctx).getString(full(key), null)?.trim().orEmpty().ifEmpty { fallback }
        } catch (_: Throwable) {
            fallback
        }
    }

    fun putString(ctx: Context, key: String, value: String) {
        try {
            prefs(ctx).edit().putString(full(key), value).apply()
        } catch (_: Throwable) {
        }
    }

    fun getBool(ctx: Context, key: String, fallback: Boolean = false): Boolean {
        return try {
            prefs(ctx).getBoolean(full(key), fallback)
        } catch (_: Throwable) {
            fallback
        }
    }

    fun putBool(ctx: Context, key: String, value: Boolean) {
        try {
            prefs(ctx).edit().putBoolean(full(key), value).apply()
        } catch (_: Throwable) {
        }
    }

    fun getLong(ctx: Context, key: String, fallback: Long = 0L): Long {
        return try {
            prefs(ctx).getLong(full(key), fallback)
        } catch (_: Throwable) {
            fallback
        }
    }

    fun getDouble(ctx: Context, key: String): Double? {
        val raw = try {
            prefs(ctx).getString(full(key), null)
        } catch (_: Throwable) {
            null
        } ?: return null

        val body = if (raw.startsWith(DOUBLE_PREFIX)) raw.substring(DOUBLE_PREFIX.length) else raw
        return body.trim().toDoubleOrNull()
    }

    fun remove(ctx: Context, key: String) {
        try {
            prefs(ctx).edit().remove(full(key)).apply()
        } catch (_: Throwable) {
        }
    }

    fun getStringList(ctx: Context, key: String): List<String> {
        val raw = try {
            prefs(ctx).getString(full(key), null)
        } catch (_: Throwable) {
            null
        } ?: return emptyList()

        if (raw.isBlank()) return emptyList()

        val body = if (raw.startsWith(LIST_IDENTIFIER)) {
            raw.substring(LIST_IDENTIFIER.length)
        } else {
            raw
        }

        decodeJsonList(body)?.let { return it }
        decodeSerializedList(body)?.let { return it }
        return emptyList()
    }

    private fun decodeJsonList(body: String): List<String>? {
        val trimmed = body.trim()
        if (!trimmed.startsWith("[")) return null
        return try {
            val arr = JSONArray(trimmed)
            val out = ArrayList<String>(arr.length())
            for (i in 0 until arr.length()) {
                val v = arr.optString(i).trim()
                if (v.isNotEmpty()) out.add(v)
            }
            out
        } catch (_: Throwable) {
            null
        }
    }

    private fun decodeSerializedList(body: String): List<String>? {
        return try {
            val bytes = Base64.decode(body, Base64.DEFAULT)
            ObjectInputStream(ByteArrayInputStream(bytes)).use { ois ->
                val obj = ois.readObject()
                if (obj !is List<*>) return null
                val out = ArrayList<String>()
                for (item in obj) {
                    val s = item?.toString()?.trim().orEmpty()
                    if (s.isNotEmpty()) out.add(s)
                }
                out
            }
        } catch (_: Throwable) {
            null
        }
    }
}
