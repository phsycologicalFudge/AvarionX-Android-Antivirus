package com.colourswift.vxtitanium

import com.sun.jna.Library
import com.sun.jna.Native
import com.sun.jna.Pointer

@Suppress("FunctionName")
internal interface VxTitaniumNative : Library {
    fun vx_init(defs_dir: String, key_path: String): Int
    fun vx_scan_file(path: String): Pointer?
    fun vx_free_result(result: Pointer)
    fun vx_dispose()

    companion object {
        val INSTANCE: VxTitaniumNative by lazy {
            Native.load("colourswift_av", VxTitaniumNative::class.java)
        }
    }
}
