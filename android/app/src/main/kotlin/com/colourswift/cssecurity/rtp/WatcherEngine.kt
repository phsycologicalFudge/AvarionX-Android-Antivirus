package com.colourswift.cssecurity.rtp

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
    val timestampMs: Long,
    val pidLifetimeSec: Int = 0,
    val deltaWriteBytes: Long = 0L,
    val deltaSyscw: Long = 0L,
    val deltaCpuJiffies: Long = 0L,
    val threads: Int = 0,
    val uidWriteBurstBytes: Long = 0L,
    val uidSyscwBurst: Long = 0L,
    val uidCpuBurstJiffies: Long = 0L,
    val uidPidChurn: Int = 0
)

data class HeuristicResult(
    val verdict: WatcherVerdict,
    val score: Int,
    val reasons: List<String>,
    val matchedRuleIds: List<String>
)

data class Rule(
    val id: String,
    val whenExpr: Expr,
    val addScore: Int,
    val reason: String
)

sealed class Expr {
    abstract fun eval(s: ProcessSnapshot): Boolean

    data class Atom(val key: Key, val negated: Boolean = false) : Expr() {
        override fun eval(s: ProcessSnapshot): Boolean {
            val v = when (key) {
                Key.FG -> s.hasForegroundService
                Key.COMP -> s.hasComponentMatch
                Key.RW_LIKE -> isRansomwareLike(s)
            }
            return if (negated) !v else v
        }
    }

    data class Num(val key: NumKey, val op: NumOp, val value: Long) : Expr() {
        override fun eval(s: ProcessSnapshot): Boolean {
            val v = when (key) {
                NumKey.DELTA_WRITE_BYTES -> s.deltaWriteBytes
                NumKey.DELTA_SYSCW -> s.deltaSyscw
                NumKey.DELTA_CPU_JIFFIES -> s.deltaCpuJiffies
                NumKey.THREADS -> s.threads.toLong()
                NumKey.UID_WRITE_BURST_BYTES -> s.uidWriteBurstBytes
                NumKey.UID_SYSCW_BURST -> s.uidSyscwBurst
                NumKey.UID_CPU_BURST_JIFFIES -> s.uidCpuBurstJiffies
                NumKey.UID_PID_CHURN -> s.uidPidChurn.toLong()
                NumKey.PID_LIFETIME_SEC -> s.pidLifetimeSec.toLong()
            }

            return when (op) {
                NumOp.GT -> v > value
                NumOp.GTE -> v >= value
                NumOp.LT -> v < value
                NumOp.LTE -> v <= value
                NumOp.EQ -> v == value
                NumOp.NEQ -> v != value
            }
        }
    }

    data class And(val a: Expr, val b: Expr) : Expr() {
        override fun eval(s: ProcessSnapshot) = a.eval(s) && b.eval(s)
    }

    data class Or(val a: Expr, val b: Expr) : Expr() {
        override fun eval(s: ProcessSnapshot) = a.eval(s) || b.eval(s)
    }

    data class Not(val x: Expr) : Expr() {
        override fun eval(s: ProcessSnapshot) = !x.eval(s)
    }
}

enum class Key { FG, COMP, RW_LIKE }

enum class NumKey {
    DELTA_WRITE_BYTES,
    DELTA_SYSCW,
    DELTA_CPU_JIFFIES,
    THREADS,
    UID_WRITE_BURST_BYTES,
    UID_SYSCW_BURST,
    UID_CPU_BURST_JIFFIES,
    UID_PID_CHURN,
    PID_LIFETIME_SEC
}

enum class NumOp { GT, GTE, LT, LTE, EQ, NEQ }

class WatcherRuleSet(
    val escalateThreshold: Int,
    val blockThreshold: Int?,
    val rules: List<Rule>
)

object WatcherEngine {
    var logSink: ((String) -> Unit)? = null

    var onBlock: ((ProcessSnapshot, HeuristicResult) -> Unit)? = null
    var onEscalate: ((ProcessSnapshot, HeuristicResult) -> Unit)? = null

    private fun log(line: String) {
        try {
            logSink?.invoke(line)
        } catch (_: Throwable) {
        }
    }

    fun evaluate(s: ProcessSnapshot, ruleSet: WatcherRuleSet): HeuristicResult {
        var score = 0
        val reasons = ArrayList<String>(6)
        val matched = ArrayList<String>(6)

        for (r in ruleSet.rules) {
            if (r.whenExpr.eval(s)) {
                score += r.addScore
                matched.add(r.id)
                if (r.reason.isNotEmpty()) reasons.add(r.reason)
            }
        }

        val verdict =
            if (ruleSet.blockThreshold != null && score >= ruleSet.blockThreshold) WatcherVerdict.BLOCK
            else if (score >= ruleSet.escalateThreshold) WatcherVerdict.ESCALATE
            else WatcherVerdict.IGNORE

        log(
            "[WATCHER] " +
                    "pid=${s.pid} " +
                    "uid=${s.uid} " +
                    "pkg=${s.packageName} " +
                    "proc=${s.processName} " +
                    "life=${s.pidLifetimeSec}s " +
                    "fg=${s.hasForegroundService} " +
                    "comp=${s.hasComponentMatch} " +
                    "dWrite=${s.deltaWriteBytes} " +
                    "dSyscw=${s.deltaSyscw} " +
                    "dCpu=${s.deltaCpuJiffies} " +
                    "thr=${s.threads} " +
                    "uWrite=${s.uidWriteBurstBytes} " +
                    "uSyscw=${s.uidSyscwBurst} " +
                    "uCpu=${s.uidCpuBurstJiffies} " +
                    "churn=${s.uidPidChurn} " +
                    "score=$score " +
                    "verdict=$verdict " +
                    "rules=${matched.joinToString(",")}"
        )

        val result = HeuristicResult(verdict, score, reasons, matched)

        when (verdict) {
            WatcherVerdict.BLOCK -> {
                try {
                    onBlock?.invoke(s, result)
                } catch (_: Throwable) {
                }
            }

            WatcherVerdict.ESCALATE -> {
                try {
                    onEscalate?.invoke(s, result)
                } catch (_: Throwable) {
                }
            }

            else -> {}
        }

        return result
    }
}

private fun isRansomwareLike(s: ProcessSnapshot): Boolean {
    val heavySustainedWrites = s.uidWriteBurstBytes >= 80_000_000L
    val heavySustainedCpu = s.uidCpuBurstJiffies >= 900L
    val heavySustainedSyscw = s.uidSyscwBurst >= 1200L

    val spikeNow = s.deltaWriteBytes >= 8_000_000L && s.deltaSyscw >= 250L
    val threadSpike = s.threads >= 40 && s.deltaCpuJiffies >= 150L
    val churn = s.uidPidChurn >= 6 && s.pidLifetimeSec <= 8

    val base = (heavySustainedWrites && (heavySustainedCpu || heavySustainedSyscw)) ||
            (heavySustainedSyscw && heavySustainedCpu)

    return base && (spikeNow || threadSpike || churn)
}