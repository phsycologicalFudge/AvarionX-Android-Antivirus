package com.colourswift.cssecurity

import android.content.ComponentName
import android.content.Context
import android.content.ServiceConnection
import android.content.pm.PackageManager
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.util.Log
import com.colourswift.cssecurity.rtp.SystemWatcher
import com.colourswift.cssecurity.rtp.SystemWatcherUserService
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import rikka.shizuku.Shizuku
import java.util.concurrent.Executors

class ShizukuBridge(
    private val context: Context
) : MethodChannel.MethodCallHandler {

    @Volatile private var binderReady = false
    @Volatile private var service: ISystemWatcherService? = null

    private val io = Executors.newSingleThreadExecutor()

    private val userServiceArgs = Shizuku.UserServiceArgs(
        ComponentName(context.packageName, SystemWatcherUserService::class.java.name)
    )
        .daemon(false)
        .processNameSuffix("shizuku_cleaner")
        .debuggable(BuildConfig.DEBUG)
        .version(BuildConfig.VERSION_CODE)

    private val serviceConnection = object : ServiceConnection {
        override fun onServiceConnected(name: ComponentName?, binder: IBinder?) {
            val svc = ISystemWatcherService.Stub.asInterface(binder)
            service = svc
            Log.i("ShizukuBridge", "Shell service connected")
            SystemWatcher.start(context, svc)
        }

        override fun onServiceDisconnected(name: ComponentName?) {
            service = null
            Log.i("ShizukuBridge", "Shell service disconnected")
            SystemWatcher.stop()
        }
    }

    private val received = Shizuku.OnBinderReceivedListener {
        binderReady = true
        if (Shizuku.checkSelfPermission() == PackageManager.PERMISSION_GRANTED) {
            bindService()
        }
    }

    private val dead = Shizuku.OnBinderDeadListener {
        binderReady = false
        service = null
    }

    init {
        binderReady = Shizuku.pingBinder()
        Shizuku.addBinderReceivedListener(received)
        Shizuku.addBinderDeadListener(dead)

        if (binderReady &&
            Shizuku.checkSelfPermission() == PackageManager.PERMISSION_GRANTED
        ) {
            bindService()
        }
    }

    private fun bindService() {
        try {
            Shizuku.bindUserService(userServiceArgs, serviceConnection)
        } catch (e: Exception) {
            Log.e("ShizukuBridge", "bindService failed: ${e.message}")
        }
    }

    fun destroy() {
        Shizuku.removeBinderReceivedListener(received)
        Shizuku.removeBinderDeadListener(dead)
        disable()
        io.shutdown()
    }

    private fun disable() {
        SystemWatcher.stop()
        service = null

        try {
            Shizuku.unbindUserService(userServiceArgs, serviceConnection, true)
        } catch (e: Exception) {
            Log.w("ShizukuBridge", "disable unbind failed: ${e.message}")
        }
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
                if (Shizuku.checkSelfPermission() == PackageManager.PERMISSION_GRANTED) {
                    bindService()
                }
                result.success(true)
            }

            "isServiceBound" -> {
                result.success(service != null)
            }

            "disable" -> {
                disable()
                result.success(true)
            }

            "uninstallPackage" -> {
                val pkg = call.argument<String>("package") ?: ""
                runShell(pkg, result) { svc ->
                    svc.shOut("pm uninstall --user 0 $pkg")
                        .contains("Success", ignoreCase = true)
                }
            }

            "clearCache" -> {
                val pkg = call.argument<String>("package") ?: ""
                runShell(pkg, result) { svc ->
                    svc.shExit("cmd package clear-cache $pkg") == 0
                }
            }

            "clearAllCaches" -> {
                runShellNoPackage(result) { svc ->
                    svc.shExit("pm trim-caches 999G") == 0
                }
            }

            "clearData" -> {
                val pkg = call.argument<String>("package") ?: ""
                runShell(pkg, result) { svc ->
                    svc.shOut("pm clear $pkg")
                        .contains("Success", ignoreCase = true)
                }
            }

            "forceStop" -> {
                val pkg = call.argument<String>("package") ?: ""
                runShell(pkg, result) { svc ->
                    svc.shExit("am force-stop $pkg") == 0
                }
            }

            else -> result.notImplemented()
        }
    }

    private fun runShell(
        pkg: String,
        result: MethodChannel.Result,
        block: (ISystemWatcherService) -> Boolean
    ) {
        val svc = service
        if (svc == null) {
            result.error("NO_SERVICE", "Shizuku service not bound", null)
            return
        }
        if (pkg.isBlank() || !pkg.matches(Regex("^[A-Za-z0-9._]+$"))) {
            result.success(false)
            return
        }
        io.execute {
            try {
                val ok = block(svc)
                Handler(Looper.getMainLooper()).post { result.success(ok) }
            } catch (e: Exception) {
                Handler(Looper.getMainLooper()).post {
                    result.error("ERR", e.message, null)
                }
            }
        }
    }

    private fun runShellNoPackage(
        result: MethodChannel.Result,
        block: (ISystemWatcherService) -> Boolean
    ) {
        val svc = service
        if (svc == null) {
            result.error("NO_SERVICE", "Shizuku service not bound", null)
            return
        }
        io.execute {
            try {
                val ok = block(svc)
                Handler(Looper.getMainLooper()).post { result.success(ok) }
            } catch (e: Exception) {
                Handler(Looper.getMainLooper()).post {
                    result.error("ERR", e.message, null)
                }
            }
        }
    }
}