package com.colourswift.cssecurity

import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class ManagerBridge(
    private val context: Context
) : MethodChannel.MethodCallHandler {

    private val managerPackage = "com.colourswift.avarionx.manager"

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "isManagerInstalled" -> {
                result.success(isManagerInstalled())
            }
            "openManager" -> {
                val opened = openManager()
                result.success(opened)
            }
            else -> result.notImplemented()
        }
    }

    private fun isManagerInstalled(): Boolean {
        return try {
            context.packageManager.getPackageInfo(managerPackage, 0)
            true
        } catch (_: PackageManager.NameNotFoundException) {
            false
        }
    }

    private fun openManager(): Boolean {
        val intent = context.packageManager
            .getLaunchIntentForPackage(managerPackage)
            ?: return false

        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        context.startActivity(intent)
        return true
    }
}
