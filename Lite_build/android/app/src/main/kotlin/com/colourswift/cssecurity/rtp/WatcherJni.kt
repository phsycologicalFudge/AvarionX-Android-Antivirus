package com.colourswift.cssecurity.rtp

object WatcherJni {
    init {
        System.loadLibrary("colourswift_av")
    }

    external fun watcherEvaluate(
        uid: Int,
        pid: Int,
        lifetimeSec: Int,
        threads: Int,
        pidChurn: Int,
        fg: Int,
        comp: Int,
        deltaWrite: Long,
        deltaSyscw: Long,
        deltaCpu: Long,
        burstWrite: Long,
        burstSyscw: Long,
        burstCpu: Long,
        fsEventsTotal: Int,
        fsCreateCount: Int,
        fsModifyCount: Int,
        fsDeleteCount: Int,
        fsSuspiciousExtCount: Int,
        fsLockedExtCount: Int,
        fsCopyLikeCount: Int,
        fsEncryptLikeCount: Int,
        fsSourceOnlyCount: Int,
        fsTotalBytesChanged: Long,
        fsUniqueDirsTouched: Int,
        fsUniqueExtTouched: Int,
        screenLocked: Int,
        deviceAdmin: Int,
        pkgNameEntropy: Int,
    ): Int

    fun unpackVerdict(r: Int): Int = r
}
