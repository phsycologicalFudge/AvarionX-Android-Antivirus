package com.colourswift.cssecurity.terminal.bridge

import android.content.Context
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.os.ParcelFileDescriptor
import android.util.Log
import com.colourswift.cssecurity.ISystemWatcherService
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformViewRegistry
import java.io.File

object AXTerminalPlugin {
    private var session: PtyTermSession? = null

    @Volatile private var shizukuService: ISystemWatcherService? = null
    @Volatile private var eventSink: EventChannel.EventSink? = null

    fun setShizukuService(svc: ISystemWatcherService?) {
        shizukuService = svc
        session?.shizukuService = svc
        if (svc != null) {
            killSession()
            Handler(Looper.getMainLooper()).post {
                eventSink?.success("shizuku_ready")
            }
        }
    }

    fun register(
        context: Context,
        messenger: BinaryMessenger,
        registry: PlatformViewRegistry? = null,
    ) {
        BusyboxInstaller.install(context.applicationContext)

        registry?.registerViewFactory(
            "ax_terminal_view",
            AXEmulatorViewFactory { session }
        )

        EventChannel(messenger, "ax_terminal_events").setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, sink: EventChannel.EventSink) {
                    eventSink = sink
                    session?.eventSink = sink
                }
                override fun onCancel(arguments: Any?) {
                    eventSink = null
                    session?.eventSink = null
                }
            }
        )

        MethodChannel(messenger, "ax_terminal").setMethodCallHandler { call, result ->
            when (call.method) {
                "start" -> {
                    val shellArg = call.argument<String>("shell") ?: "alpine"

                    if (session?.isRunning == true) {
                        result.success(null)
                        return@setMethodCallHandler
                    }

                    Thread {
                        var waited = 0
                        while (shizukuService == null && waited < 3000) {
                            Thread.sleep(100)
                            waited += 100
                        }

                        if (shellArg == "alpine") {
                            val svc = shizukuService
                            val installed = if (svc != null) {
                                svc.isAlpineInstalled("/data/local/tmp/ax_alpine")
                            } else {
                                AlpineInstaller.isInstalled(context.applicationContext)
                            }
                            if (!installed) {
                                Handler(Looper.getMainLooper()).post {
                                    result.error("NEEDS_ALPINE", "Alpine Linux not installed", null)
                                }
                                return@Thread
                            }
                        }

                        val newSession = newSession(context.applicationContext, shellArg)
                        if (!newSession.spawn()) {
                            Handler(Looper.getMainLooper()).post {
                                result.error("SPAWN_FAILED", "PTY execution context failed", null)
                            }
                            return@Thread
                        }
                        session = newSession
                        if (shellArg == "android") {
                            Thread.sleep(300)
                            newSession.write(byteArrayOf(0x0A), 0, 1)
                        }
                        Handler(Looper.getMainLooper()).post { result.success(null) }
                    }.start()
                }

                "write" -> {
                    val text  = call.argument<String>("text") ?: ""
                    val bytes = text.toByteArray(Charsets.UTF_8)
                    session?.write(bytes, 0, bytes.size)
                    result.success(null)
                }

                "injectOutput" -> {
                    val text = call.argument<String>("text") ?: ""
                    session?.injectOutput(text)
                    result.success(null)
                }

                "sendCtrlC" -> {
                    session?.write(byteArrayOf(0x03), 0, 1)
                    result.success(null)
                }

                "sendCtrlD" -> {
                    session?.write(byteArrayOf(0x04), 0, 1)
                    result.success(null)
                }

                "sendCtrlZ" -> {
                    session?.write(byteArrayOf(0x1A), 0, 1)
                    result.success(null)
                }

                "reset" -> {
                    killSession()
                    val newSession = newSession(context.applicationContext)
                    if (!newSession.spawn()) {
                        result.error("SPAWN_FAILED", "PTY execution context failed", null)
                        return@setMethodCallHandler
                    }
                    session = newSession
                    result.success(null)
                }

                "installAlpine" -> {
                    val svc = shizukuService
                    if (svc != null) {
                        val shizukuDir = "/data/local/tmp/ax_alpine"
                        Thread {
                            try {
                                if (svc.isAlpineInstalled(shizukuDir)) {
                                    Handler(Looper.getMainLooper()).post {
                                        result.success("already_installed")
                                    }
                                    return@Thread
                                }
                                val pfd     = copyAssetToTemp(context, alpineAssetPath())
                                val success = svc.installAlpine(pfd, shizukuDir)
                                pfd.close()
                                Handler(Looper.getMainLooper()).post {
                                    if (success) result.success("installed")
                                    else result.error("INSTALL_FAILED", "Shizuku extraction failed", null)
                                }
                            } catch (e: Exception) {
                                Handler(Looper.getMainLooper()).post {
                                    result.error("INSTALL_FAILED", e.message, null)
                                }
                            }
                        }.start()
                    } else {
                        if (AlpineInstaller.isInstalled(context.applicationContext)) {
                            result.success("already_installed")
                            return@setMethodCallHandler
                        }
                        Thread {
                            try {
                                AlpineInstaller.install(context.applicationContext) {}
                                Handler(Looper.getMainLooper()).post {
                                    result.success("installed")
                                }
                            } catch (e: Exception) {
                                Handler(Looper.getMainLooper()).post {
                                    result.error("INSTALL_FAILED", e.message, null)
                                }
                            }
                        }.also {
                            it.isDaemon = true
                            it.name     = "AlpineInstaller"
                            it.start()
                        }
                    }
                }

                else -> result.notImplemented()
            }
        }
    }

    fun killSession() {
        session?.finish()
        session = null
    }

    private fun newSession(context: Context, shellMode: String = "alpine") =
        PtyTermSession(context).also {
            it.shizukuService = shizukuService
            it.shellMode      = shellMode
            it.eventSink      = eventSink
        }

    private fun alpineAssetPath() =
        if (Build.SUPPORTED_64_BIT_ABIS.isNotEmpty())
            "flutter_assets/assets/linux/alpine-arm64.tar.gz"
        else
            "flutter_assets/assets/linux/alpine-arm32.tar.gz"

    private fun copyAssetToTemp(context: Context, assetPath: String): ParcelFileDescriptor {
        val tmp = File(context.cacheDir, "alpine_transfer.tar.gz")
        context.assets.open(assetPath).use { input ->
            tmp.outputStream().use { output -> input.copyTo(output) }
        }
        return ParcelFileDescriptor.open(tmp, ParcelFileDescriptor.MODE_READ_ONLY)
    }
}