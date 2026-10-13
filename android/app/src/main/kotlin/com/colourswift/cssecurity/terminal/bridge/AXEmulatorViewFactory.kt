package com.colourswift.cssecurity.terminal.bridge

import android.content.Context
import android.view.MotionEvent
import android.view.View
import android.view.inputmethod.InputMethodManager
import com.colourswift.cssecurity.terminal.render.ColorScheme
import com.colourswift.cssecurity.terminal.view.EmulatorView
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class AXEmulatorViewFactory(
    private val getSession: () -> PtyTermSession?
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val s = getSession()
        android.util.Log.d("AXTerminal", "Factory.create: session=${if (s != null) "present isRunning=${s.isRunning}" else "NULL"}")
        return AXEmulatorPlatformView(context, s)
    }
}

private class AXEmulatorPlatformView(
    private val context: Context,
    session: PtyTermSession?,
) : PlatformView {

    private lateinit var view: EmulatorView

    init {
        val metrics = context.resources.displayMetrics
        view = EmulatorView(context, null as android.util.AttributeSet?)
        view.setDensity(metrics)

        view.setBackgroundColor(0xFF000000.toInt())

        android.util.Log.d("AXTerminal", "PlatformView.init: session=${if (session != null) "present" else "NULL"}")

        if (session != null) {
            session.spawn()
            view.attachSession(session)

            android.util.Log.d("AXTerminal", "PlatformView.init: attachSession done")

            view.setColorScheme(ColorScheme(
                0xFFCCCCCC.toInt(),
                0xFF000000.toInt(),
                0xFF000000.toInt(),
                0xFF4FC1FF.toInt(),
            ))
            view.setTextSize(13)

            view.invalidate()
        }

        view.setOnTouchListener { v, event ->
            if (event.action == MotionEvent.ACTION_UP) {
                v.requestFocus()
                val imm = context.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
                imm.showSoftInput(v, InputMethodManager.SHOW_IMPLICIT)
            }
            false
        }
    }

    override fun getView(): View = view

    override fun dispose() {}
}