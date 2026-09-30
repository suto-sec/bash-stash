# 1437 · balance.sh: checking parentheses balance

**Topic:** test, if & case · **Difficulty:** ★★★★☆ · **Commands:** case, test -eq -lt, while, exit codes

Write `balance.sh STRING` (exactly one argument, or it is a usage error). STRING is meant to contain
only the characters `(` and `)`; validate that first: if any other character appears, print a message
on stderr **naming the whole string**, exit **2**.

Otherwise scan it left to right, character by character (`${STRING:i:1}` and a `case`), keeping a
running counter that goes up on `(` and down on `)`. If the counter ever goes **negative**, print
`desbalanceado: cierre extra en posicion P` (P = the 1-based position, that is `i+1`, where it first
went negative) and stop scanning right there. Otherwise, after the whole string, print `balanceado`
if the counter is exactly 0, or `desbalanceado: faltan N cierres` (N = the final counter value) if
it's positive.

Errors (stderr, wording free): not exactly 1 argument -> usage, exit **1**. Success or a detected
imbalance always exits **0** — only argument errors give a non-zero exit code.

---
Write your solution in `answer.sh`, then run `check 1437`.  
To experiment with the same test files the checker uses: `play 1437`.
