package com.colourswift.cssecurity.rtp

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import io.flutter.plugin.common.EventChannel

class RealtimeReceiver(private var events: EventChannel.EventSink? = null) : BroadcastReceiver() {

    override fun onReceive(context: Context?, intent: Intent?) {
        val path = intent?.getStringExtra("path") ?: return
        Log.i("CSRealtime", "Detected new file: $path")
        events?.success(path)
    }

    fun setEventSink(sink: EventChannel.EventSink?) {
        this.events = sink
    }
}
