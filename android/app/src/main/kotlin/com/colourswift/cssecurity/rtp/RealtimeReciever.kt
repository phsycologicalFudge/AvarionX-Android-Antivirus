package com.colourswift.cssecurity.rtp

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import io.flutter.plugin.common.EventChannel

class RealtimeReceiver : BroadcastReceiver() {

    companion object {
        @Volatile
        var events: EventChannel.EventSink? = null
    }

    override fun onReceive(context: Context?, intent: Intent?) {
        val path = intent?.getStringExtra("path") ?: return
        Log.i("CSRealtime", "Detected new file: $path")
        events?.success(path)
    }
}