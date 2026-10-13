package com.colourswift.cssecurity.vpn.backend_port.health

import android.content.Context
import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import android.net.NetworkRequest
import java.util.concurrent.atomic.AtomicBoolean

class NetworkStateWatcher(
    private val context: Context,
    private val onConnectivityChanged: (Boolean) -> Unit
) {

    private val registered = AtomicBoolean(false)
    private var callback: ConnectivityManager.NetworkCallback? = null

    @Volatile
    var hasConnectivity: Boolean = true
        private set

    private fun cm(): ConnectivityManager? {
        return try {
            context.applicationContext
                .getSystemService(Context.CONNECTIVITY_SERVICE) as? ConnectivityManager
        } catch (_: Throwable) {
            null
        }
    }

    fun currentlyHasUnderlyingNetwork(): Boolean {
        val manager = cm() ?: return true
        return try {
            manager.allNetworks.any { n ->
                val caps = manager.getNetworkCapabilities(n) ?: return@any false
                caps.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET) &&
                    caps.hasCapability(NetworkCapabilities.NET_CAPABILITY_NOT_VPN)
            }
        } catch (_: Throwable) {
            true
        }
    }

    fun start() {
        if (!registered.compareAndSet(false, true)) return

        val manager = cm() ?: run {
            registered.set(false)
            return
        }

        hasConnectivity = currentlyHasUnderlyingNetwork()

        val request = NetworkRequest.Builder()
            .addCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)
            .addCapability(NetworkCapabilities.NET_CAPABILITY_NOT_VPN)
            .build()

        val cb = object : ConnectivityManager.NetworkCallback() {
            override fun onAvailable(network: Network) {
                publish(true)
            }

            override fun onLost(network: Network) {
                publish(currentlyHasUnderlyingNetwork())
            }

            override fun onUnavailable() {
                publish(false)
            }
        }

        callback = cb

        try {
            manager.registerNetworkCallback(request, cb)
        } catch (_: Throwable) {
            registered.set(false)
            callback = null
        }
    }

    fun stop() {
        if (!registered.compareAndSet(true, false)) return
        val manager = cm() ?: return
        val cb = callback ?: return
        try {
            manager.unregisterNetworkCallback(cb)
        } catch (_: Throwable) {
        }
        callback = null
    }

    private fun publish(value: Boolean) {
        val previous = hasConnectivity
        hasConnectivity = value
        if (previous != value) {
            try {
                onConnectivityChanged(value)
            } catch (_: Throwable) {
            }
        }
    }
}
