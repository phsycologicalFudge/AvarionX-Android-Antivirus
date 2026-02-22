package com.colourswift.cssecurity.rtp

object WatcherRuleParser {

    fun parse(text: String): WatcherRuleSet {
        var escalate = 3
        var block: Int? = null
        val rules = ArrayList<Rule>()

        val lines = text.lines()
            .map { it.trim() }
            .filter { it.isNotEmpty() && !it.startsWith("#") }

        for (line in lines) {
            if (line.startsWith("threshold ")) {
                val parts = line.removePrefix("threshold ").trim().split(" ")
                for (p in parts) {
                    val kv = p.split("=", limit = 2)
                    if (kv.size == 2) {
                        when (kv[0].trim()) {
                            "escalate" -> escalate = kv[1].trim().toInt()
                            "block" -> block = kv[1].trim().toInt()
                        }
                    }
                }
                continue
            }

            if (line.startsWith("rule ")) {
                val after = line.removePrefix("rule ").trim()
                val idx = after.indexOf(":")
                require(idx > 0) { "Invalid rule header: $line" }
                val id = after.substring(0, idx).trim()
                val body = after.substring(idx + 1).trim()

                val bodyParts = body.split(" reason ", limit = 2)
                val pre = bodyParts[0].trim()
                val reason = if (bodyParts.size == 2) bodyParts[1].trim() else ""

                require(pre.startsWith("if ")) { "Rule must start with if: $line" }
                val pre2 = pre.removePrefix("if ").trim()

                val addIdx = pre2.lastIndexOf(" add ")
                require(addIdx > 0) { "Rule missing add: $line" }

                val exprStr = pre2.substring(0, addIdx).trim()
                val addStr = pre2.substring(addIdx + " add ".length).trim()
                val add = addStr.toInt()

                val expr = ExprParser(exprStr).parseExpr()
                rules.add(Rule(id = id, whenExpr = expr, addScore = add, reason = reason))
                continue
            }

            throw IllegalArgumentException("Unknown line: $line")
        }

        return WatcherRuleSet(escalateThreshold = escalate, blockThreshold = block, rules = rules)
    }

    private class ExprParser(private val src: String) {
        private var i = 0

        fun parseExpr(): Expr {
            var left = parseTerm()
            while (true) {
                skipWs()
                if (matchWord("or")) {
                    val right = parseTerm()
                    left = Expr.Or(left, right)
                    continue
                }
                break
            }
            return left
        }

        private fun parseTerm(): Expr {
            var left = parseFactor()
            while (true) {
                skipWs()
                if (matchWord("and")) {
                    val right = parseFactor()
                    left = Expr.And(left, right)
                    continue
                }
                break
            }
            return left
        }

        private fun parseFactor(): Expr {
            skipWs()
            if (peek() == '(') {
                i++
                val e = parseExpr()
                skipWs()
                require(peek() == ')') { "Missing ) in: $src" }
                i++
                return e
            }

            var neg = false
            if (peek() == '!') {
                neg = true
                i++
            }

            val key = readIdent().lowercase()
            val k = when (key) {
                "fg" -> Key.FG
                "comp" -> Key.COMP
                else -> throw IllegalArgumentException("Unknown key '$key' in: $src")
            }
            return Expr.Atom(k, negated = neg)
        }

        private fun readIdent(): String {
            skipWs()
            val start = i
            while (i < src.length) {
                val c = src[i]
                val ok = c.isLetterOrDigit() || c == '_' || c == '-'
                if (!ok) break
                i++
            }
            require(i > start) { "Expected identifier in: $src" }
            return src.substring(start, i)
        }

        private fun matchWord(w: String): Boolean {
            skipWs()
            val end = i + w.length
            if (end > src.length) return false
            if (src.substring(i, end) != w) return false
            val prevOk = i == 0 || !src[i - 1].isLetterOrDigit()
            val nextOk = end == src.length || !src[end].isLetterOrDigit()
            if (!prevOk || !nextOk) return false
            i = end
            return true
        }

        private fun skipWs() {
            while (i < src.length && src[i].isWhitespace()) i++
        }

        private fun peek(): Char? = if (i < src.length) src[i] else null
    }
}