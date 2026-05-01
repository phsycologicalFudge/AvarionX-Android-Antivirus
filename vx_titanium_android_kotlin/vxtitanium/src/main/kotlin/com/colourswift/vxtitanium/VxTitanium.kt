package com.colourswift.vxtitanium

class VxTitanium {
    private val native: VxTitaniumNative = VxTitaniumNative.INSTANCE
    private var disposed = false

    fun init(defsDir: String, keyPath: String): Int {
        check(!disposed) { "VxTitanium instance has been disposed" }
        return native.vx_init(defsDir, keyPath)
    }

    fun scanFile(path: String): String? {
        check(!disposed) { "VxTitanium instance has been disposed" }
        val ptr = native.vx_scan_file(path) ?: return null
        return try {
            ptr.getString(0)
        } finally {
            native.vx_free_result(ptr)
        }
    }

    fun dispose() {
        if (!disposed) {
            native.vx_dispose()
            disposed = true
        }
    }
}
