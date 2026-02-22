package com.colourswift.cssecurity.rtp

object WatcherHeuristics {

    fun ruleSet(): WatcherRuleSet {
        val rules = listOf(
            Rule(
                id = "rw_like",
                whenExpr = Expr.Atom(Key.RW_LIKE, negated = false),
                addScore = 6,
                reason = "Ransomware-like behavior"
            ),
            Rule(
                id = "burst_write",
                whenExpr = Expr.Num(NumKey.UID_WRITE_BURST_BYTES, NumOp.GTE, 80_000_000L),
                addScore = 4,
                reason = "Heavy sustained writes"
            ),
            Rule(
                id = "burst_syscw",
                whenExpr = Expr.Num(NumKey.UID_SYSCW_BURST, NumOp.GTE, 1200L),
                addScore = 3,
                reason = "High syscall write activity"
            ),
            Rule(
                id = "thread_spike",
                whenExpr = Expr.And(
                    Expr.Num(NumKey.THREADS, NumOp.GTE, 40L),
                    Expr.Num(NumKey.DELTA_CPU_JIFFIES, NumOp.GTE, 150L)
                ),
                addScore = 2,
                reason = "Thread and CPU spike"
            ),
            Rule(
                id = "pid_churn",
                whenExpr = Expr.And(
                    Expr.Num(NumKey.UID_PID_CHURN, NumOp.GTE, 6L),
                    Expr.Num(NumKey.PID_LIFETIME_SEC, NumOp.LTE, 8L)
                ),
                addScore = 2,
                reason = "Rapid process churn"
            )
        )

        return WatcherRuleSet(
            escalateThreshold = 5,
            blockThreshold = 8,
            rules = rules
        )
    }
}