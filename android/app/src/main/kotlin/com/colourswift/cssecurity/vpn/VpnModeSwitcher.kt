package com.colourswift.cssecurity.vpn

import android.content.Context
import android.content.Intent
import android.os.Build
import com.colourswift.cssecurity.vpn.wireguard.CSWireGuardService
import java.util.concurrent.Executors

object VpnModeSwitcher {

    private val worker = Executors.newSingleThreadExecutor()

    private fun startCompat(ctx: Context, i: Intent, isStartAction: Boolean) {
        if (isStartAction && Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            ctx.startForegroundService(i)
        } else {
            ctx.startService(i)
        }
    }

    private fun waitUntil(condition: () -> Boolean, timeoutMs: Long) {
        val start = System.currentTimeMillis()
        while (System.currentTimeMillis() - start < timeoutMs) {
            if (condition()) return
            try { Thread.sleep(80) } catch (_: Throwable) {}
        }
    }

    fun switchToWireGuard(ctx: Context, config: String) {
        val appCtx = ctx.applicationContext
        worker.execute {
            stopDnsVpn(appCtx)
            waitUntil({ !CSVpnService.isRunning }, 5000)
            startWireGuard(appCtx, config)
        }
    }

    fun switchToDnsVpn(ctx: Context) {
        val appCtx = ctx.applicationContext
        worker.execute {
            stopWireGuard(appCtx)
            waitUntil({ !CSWireGuardService.isRunning }, 5000)
            startDnsVpn(appCtx)
        }
    }

    fun stopWireGuard(ctx: Context) {
        val i = Intent(ctx, CSWireGuardService::class.java).apply {
            action = CSWireGuardService.ACTION_STOP
        }
        startCompat(ctx, i, false)
    }

    fun startWireGuard(ctx: Context, config: String) {
        val i = Intent(ctx, CSWireGuardService::class.java).apply {
            action = CSWireGuardService.ACTION_START
            putExtra(CSWireGuardService.EXTRA_WG_CONFIG, config)
        }
        startCompat(ctx, i, true)
    }

    fun stopDnsVpn(ctx: Context) {
        val i = Intent(ctx, CSVpnService::class.java).apply {
            action = CSVpnService.ACTION_STOP
        }
        startCompat(ctx, i, false)
    }

    fun startDnsVpn(ctx: Context) {
        val i = Intent(ctx, CSVpnService::class.java).apply {
            action = CSVpnService.ACTION_START
        }
        startCompat(ctx, i, true)
    }
}
