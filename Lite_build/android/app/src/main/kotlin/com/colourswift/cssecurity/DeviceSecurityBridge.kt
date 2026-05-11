package com.colourswift.cssecurity

import android.accessibilityservice.AccessibilityServiceInfo
import android.app.KeyguardManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.view.accessibility.AccessibilityManager
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Locale

class DeviceSecurityBridge(
    private val context: Context
) : MethodChannel.MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "snapshot" -> {
                result.success(snapshot())
            }

            "openSetting" -> {
                val id = call.argument<String>("id") ?: ""
                result.success(openSetting(id))
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    private fun snapshot(): Map<String, Any> {
        return mapOf(
            "developerMode" to isDeveloperModeEnabled(),
            "developerModeAvailable" to true,

            "usbDebugging" to isUsbDebuggingEnabled(),
            "usbDebuggingAvailable" to true,

            "screenLockMissing" to isScreenLockMissing(),
            "screenLockMissingAvailable" to true,

            "unknownSources" to canThisAppRequestUnknownInstalls(),
            "unknownSourcesAvailable" to true,

            "accessibilityRisk" to hasAccessibilityRisk(),
            "accessibilityRiskAvailable" to true,

            "privilegedAccess" to hasRootSignal(),
            "privilegedAccessAvailable" to true,

            "appVerificationDisabled" to isAppVerificationDisabled(),
            "appVerificationDisabledAvailable" to true,

            "oldSecurityPatch" to isOldSecurityPatch(),
            "oldSecurityPatchAvailable" to true
        )
    }

    private fun isDeveloperModeEnabled(): Boolean {
        return getGlobalInt(Settings.Global.DEVELOPMENT_SETTINGS_ENABLED) == 1
    }

    private fun isUsbDebuggingEnabled(): Boolean {
        return getGlobalInt(Settings.Global.ADB_ENABLED) == 1
    }

    private fun isScreenLockMissing(): Boolean {
        return try {
            val keyguardManager =
                context.getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager
            keyguardManager.isDeviceSecure.not()
        } catch (_: Throwable) {
            false
        }
    }

    private fun canThisAppRequestUnknownInstalls(): Boolean {
        return try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.packageManager.canRequestPackageInstalls()
            } else {
                getSecureInt(Settings.Secure.INSTALL_NON_MARKET_APPS) == 1
            }
        } catch (_: Throwable) {
            false
        }
    }

    private fun hasAccessibilityRisk(): Boolean {
        return try {
            val accessibilityManager =
                context.getSystemService(Context.ACCESSIBILITY_SERVICE) as AccessibilityManager

            val enabledServices = accessibilityManager.getEnabledAccessibilityServiceList(
                AccessibilityServiceInfo.FEEDBACK_ALL_MASK
            )

            enabledServices.any { service ->
                val servicePackageName = service.resolveInfo.serviceInfo.packageName
                servicePackageName != context.packageName &&
                        isTrustedSystemPackage(servicePackageName).not()
            }
        } catch (_: Throwable) {
            false
        }
    }

    private fun isTrustedSystemPackage(packageName: String): Boolean {
        return packageName == "android" ||
                packageName == "com.android.systemui" ||
                packageName.startsWith("com.google.android.")
    }

    private fun hasRootSignal(): Boolean {
        val paths = arrayOf(
            "/system/bin/su",
            "/system/xbin/su",
            "/sbin/su",
            "/system/app/Superuser.apk",
            "/system/bin/.ext/.su",
            "/system/usr/we-need-root/su-backup",
            "/data/adb/magisk"
        )

        return paths.any { path ->
            try {
                File(path).exists()
            } catch (_: Throwable) {
                false
            }
        }
    }

    private fun isAppVerificationDisabled(): Boolean {
        return getGlobalInt("package_verifier_enable") == 0
    }

    private fun isOldSecurityPatch(): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            return false
        }

        val patch = Build.VERSION.SECURITY_PATCH

        if (patch.isBlank()) {
            return false
        }

        return try {
            val format = SimpleDateFormat("yyyy-MM-dd", Locale.US)
            val patchDate = format.parse(patch) ?: return false

            val limit = Calendar.getInstance()
            limit.add(Calendar.MONTH, -3)

            patchDate.before(limit.time)
        } catch (_: Throwable) {
            false
        }
    }

    private fun openSetting(id: String): Boolean {
        val intent = when (id) {
            "developer_mode",
            "usb_debugging" -> {
                Intent("android.settings.APPLICATION_DEVELOPMENT_SETTINGS")
            }

            "screen_lock",
            "app_verification" -> {
                Intent(Settings.ACTION_SECURITY_SETTINGS)
            }

            "security_patch" -> {
                Intent("android.settings.SYSTEM_UPDATE_SETTINGS")
                    .takeIf { it.resolveActivity(context.packageManager) != null }
                    ?: Intent(Settings.ACTION_SETTINGS)
            }

            "unknown_sources" -> {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    Intent(
                        Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES,
                        Uri.parse("package:${context.packageName}")
                    )
                } else {
                    Intent(Settings.ACTION_SECURITY_SETTINGS)
                }
            }

            "accessibility_risk" -> {
                Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
            }

            else -> {
                return false
            }
        }

        return try {
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(intent)
            true
        } catch (_: Throwable) {
            false
        }
    }

    private fun getGlobalInt(name: String): Int {
        return try {
            Settings.Global.getInt(context.contentResolver, name)
        } catch (_: Throwable) {
            0
        }
    }

    private fun getSecureInt(name: String): Int {
        return try {
            Settings.Secure.getInt(context.contentResolver, name)
        } catch (_: Throwable) {
            0
        }
    }
}