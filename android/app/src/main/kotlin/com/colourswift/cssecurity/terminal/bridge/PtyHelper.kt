package com.colourswift.cssecurity.terminal.bridge

object PtyHelper {
    init {
        System.loadLibrary("axpty")
    }

    external fun openMaster(rows: Int, cols: Int): Int
    external fun getSlaveName(masterFd: Int): String?
    external fun resize(masterFd: Int, rows: Int, cols: Int)
    external fun close(fd: Int)

    external fun spawnShell(
        masterFd: Int,
        slaveName: String,
        busyboxPath: String,
        homePath: String,
        prootPath: String,
        rootfsPath: String,
        cachePath: String,
        nativeLibDir: String
    ): Int

    external fun forkAndExec(
        masterFd: Int,
        slaveName: String,
        busyboxPath: String,
        homePath: String,
        prootPath: String,
        rootfsPath: String,
        cachePath: String,
        nativeLibDir: String
    ): Int
}