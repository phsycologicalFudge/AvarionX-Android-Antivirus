package com.colourswift.cssecurity.vpn

import android.content.Context
import android.content.Intent
import android.os.Build
import com.colourswift.cssecurity.vpn.wireguard.CSWireGuardService
import java.util.concurrent.Executors
import java.util.concurrent.atomic.AtomicInteger

object VpnModeSwitcher {

    private val worker = Executors.newSingleThreadExecutor()
    private val generation = AtomicInteger(0)

    private fun startCompat(ctx: Context, i: Intent, isStartAction: Boolean) {
        if (isStartAction && Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            ctx.startForegroundService(i)
        } else {
            ctx.startService(i)
        }
    }

    private fun waitUntil(condition: () -> Boolean, timeoutMs: Long, gen: Int): Boolean {
        val start = System.currentTimeMillis()
        while (System.currentTimeMillis() - start < timeoutMs) {
            if (gen != generation.get()) return false
            if (condition()) return true
            try {
                Thread.sleep(80)
            } catch (_: Throwable) {
            }
        }
        return gen == generation.get()
    }

    fun switchToWireGuard(ctx: Context, config: String, excludedAppsJson: String?) {
        val appCtx = ctx.applicationContext
        val gen = generation.incrementAndGet()
        worker.execute {
            if (gen != generation.get()) return@execute

            if (CSWireGuardService.isRunning) {
                stopWireGuard(appCtx)
            }

            val ok = waitUntil({ !CSWireGuardService.isRunning }, 5000, gen)

            if (!ok || gen != generation.get()) return@execute
            startWireGuard(appCtx, config, excludedAppsJson)
        }
    }

    fun stopWireGuard(ctx: Context) {
        val i = Intent(ctx, CSWireGuardService::class.java).apply {
            action = CSWireGuardService.ACTION_STOP
        }
        startCompat(ctx, i, false)
    }

    fun startWireGuard(ctx: Context, config: String, excludedAppsJson: String?) {
        val i = Intent(ctx, CSWireGuardService::class.java).apply {
            action = CSWireGuardService.ACTION_START
            putExtra(CSWireGuardService.EXTRA_WG_CONFIG, config)
            if (!excludedAppsJson.isNullOrBlank()) {
                putExtra(CSWireGuardService.EXTRA_EXCLUDED_APPS_JSON, excludedAppsJson)
            }
        }
        startCompat(ctx, i, true)
    }
}
