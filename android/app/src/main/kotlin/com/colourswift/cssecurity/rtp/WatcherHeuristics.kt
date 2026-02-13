package com.colourswift.cssecurity

enum class WatcherVerdict {
    IGNORE,
    ESCALATE,
    BLOCK
}

data class ProcessSnapshot(
    val uid: Int,
    val pid: Int,
    val packageName: String,
    val processName: String,
    val hasComponentMatch: Boolean,
    val hasForegroundService: Boolean,
    val timestampMs: Long
)

data class HeuristicResult(
    val verdict: WatcherVerdict,
    val score: Int,
    val reasons: List<String>
)

object WatcherHeuristics {

    private const val ESCALATE_THRESHOLD = 3

    var logSink: ((String) -> Unit)? = null

    private fun log(line: String) {
        logSink?.invoke(line)
    }

    fun evaluate(s: ProcessSnapshot): HeuristicResult {
        val reasons = mutableListOf<String>()
        var score = 0

        val now = System.currentTimeMillis()
        val lifetimeSec = ((now - s.timestampMs) / 1000).coerceAtLeast(0)

        if (!s.hasForegroundService) {
            score += 1
            reasons += "background"
        }

        if (!s.hasComponentMatch) {
            score += 1
            reasons += "headless"
        }

        val verdict =
            if (score >= ESCALATE_THRESHOLD)
                WatcherVerdict.ESCALATE
            else
                WatcherVerdict.IGNORE

        log(
            "[WATCHER] " +
                    "pid=${s.pid} " +
                    "uid=${s.uid} " +
                    "pkg=${s.packageName} " +
                    "proc=${s.processName} " +
                    "life=${lifetimeSec}s " +
                    "fg=${s.hasForegroundService} " +
                    "verdict=$verdict"
        )

        return HeuristicResult(
            verdict = verdict,
            score = score,
            reasons = reasons
        )
    }
}
