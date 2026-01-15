package com.colourswift.cssecurity

import android.content.Context
import android.content.pm.PackageManager
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import rikka.shizuku.Shizuku

class ShizukuBridge(
    private val context: Context
) : MethodChannel.MethodCallHandler {

    @Volatile
    private var binderReady = false

    private val received = Shizuku.OnBinderReceivedListener {
        binderReady = true
    }

    private val dead = Shizuku.OnBinderDeadListener {
        binderReady = false
    }

    init {
        binderReady = Shizuku.pingBinder()
        Shizuku.addBinderReceivedListener(received)
        Shizuku.addBinderDeadListener(dead)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {

            "isBinderAlive" -> {
                binderReady = Shizuku.pingBinder()
                result.success(binderReady)
            }

            "hasPermission" -> {
                if (!Shizuku.pingBinder()) {
                    binderReady = false
                    result.success(false)
                    return
                }

                binderReady = true
                result.success(
                    Shizuku.checkSelfPermission() == PackageManager.PERMISSION_GRANTED
                )
            }

            "requestPermission" -> {
                if (!Shizuku.pingBinder()) {
                    binderReady = false
                    result.success(false)
                    return
                }

                binderReady = true
                if (!Shizuku.isPreV11()) {
                    Shizuku.requestPermission(0x51A7)
                }

                result.success(true)
            }

            else -> result.notImplemented()
        }
    }
}
