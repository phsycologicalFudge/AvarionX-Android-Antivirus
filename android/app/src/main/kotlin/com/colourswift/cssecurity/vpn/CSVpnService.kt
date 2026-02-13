package com.colourswift.cssecurity.vpn

import android.content.Context
import android.content.Intent
import android.net.VpnService
import android.os.ParcelFileDescriptor
import android.provider.Settings
import android.util.Log
import com.colourswift.cssecurity.AppWifiRules
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch

class CSVpnService : VpnService() {

    companion object {
        const val ACTION_START = "com.colourswift.cssecurity.VPN_START"
        const val ACTION_STOP = "com.colourswift.cssecurity.VPN_STOP"
        const val NOTIF_ID = 200

        private const val KEY_ALWAYS_ON_APP = "always_on_vpn_app"
        private const val KEY_ALWAYS_ON_LOCKDOWN = "always_on_vpn_lockdown"

        @Volatile internal lateinit var instanceContext: Context

        fun snapshotLockdownState(ctx: Context): Map<String, Any?> {
            return try {
                val preparedIntent = VpnService.prepare(ctx)

                val alwaysOn = preparedIntent == null

                val cr = ctx.contentResolver
                val lockdownEnabled = try {
                    Settings.Secure.getInt(
                        cr,
                        "always_on_vpn_lockdown",
                        0
                    ) == 1
                } catch (_: Exception) {
                    false
                }

                mapOf(
                    "always_on" to alwaysOn,
                    "lockdown" to lockdownEnabled,
                    "always_on_pkg" to if (alwaysOn) ctx.packageName else null
                )
            } catch (_: Exception) {
                mapOf(
                    "always_on" to false,
                    "lockdown" to false,
                    "always_on_pkg" to null
                )
            }
        }
    }

    private var tun: ParcelFileDescriptor? = null

    private val serviceJob = SupervisorJob()
    private val scope = CoroutineScope(Dispatchers.IO + serviceJob)
    private var tunnelJob: kotlinx.coroutines.Job? = null

    private val fakeDnsIp = "10.0.0.1"
    private val tunIp = "10.0.0.2"

    @Volatile
    private var shouldStop = false

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val action = intent?.action
        val rawMode = intent?.getStringExtra("dns_mode")
        val reloadRules = intent?.getBooleanExtra("reload_rules", false) == true
        Log.i("CSVpn", "onStartCommand action=$action dns_mode=$rawMode reload_rules=$reloadRules")

        if (action == ACTION_STOP) {
            stopTunnel()
            stopSelf()
            return START_NOT_STICKY
        }

        CsvpnNotifications.startForegroundNotif(this)

        if (tun != null && reloadRules) {
            stopTunnel()
            startTunnel()
            return START_STICKY
        }

        startTunnel()
        return START_STICKY
    }

    private fun startTunnel() {
        if (tun != null) {
            Log.i("CSVpn", "startTunnel called but tun already exists")
            return
        }

        shouldStop = false

        val builder = Builder()
            .setSession("CS DNS Protection")
            .addAddress(tunIp, 32)
            .addDnsServer(fakeDnsIp)
            .addRoute(fakeDnsIp, 32)

        AppWifiRules.applyToBuilderIfWifiAndLockdown(this, builder)

        Log.i("CSVpn", "Establishing TUN with tunIp=$tunIp fakeDnsIp=$fakeDnsIp")

        CsvpnUsage.ensureUsageWindowAndLimit(applicationContext)

        tun = builder.establish()

        if (tun == null) {
            Log.e("CSVpn", "Failed to establish TUN")
            stopSelf()
            return
        }

        tunnelJob?.cancel()
        tunnelJob = scope.launch {
            Log.i("CSVpn", "runTunnelLoop starting")
            CsvpnTunnelLoop.run(
                service = this@CSVpnService,
                tun = tun,
                shouldStop = { shouldStop },
                fakeDnsIp = fakeDnsIp,
                cloudResolve = { dnsQuery: ByteArray, qname: String? ->
                    CsvpnCloudClient.cloudResolve(applicationContext, dnsQuery, qname)
                }
            )
            Log.i("CSVpn", "runTunnelLoop exited")
        }

        Log.i("CSVpn", "Tunnel started")
    }

    private fun stopTunnel() {
        Log.i("CSVpn", "stopTunnel called")
        shouldStop = true

        try { tun?.close() } catch (_: Exception) {}
        tun = null

        tunnelJob?.cancel()
        tunnelJob = null

        try { stopForeground(true) } catch (_: Exception) {}

        Log.i("CSVpn", "Tunnel stopped")
    }

    override fun onRevoke() {
        stopTunnel()
        super.onRevoke()
    }

    override fun onDestroy() {
        stopTunnel()
        serviceJob.cancel()
        scope.cancel()
        super.onDestroy()
    }
}
