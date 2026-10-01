# 1441 · numeric_range.sh: validating that every argument is an integer within a range

**Topic:** test, if & case · **Difficulty:** ★★★★☆ · **Commands:** test -lt -gt, [[ =~ ]], for, exit codes

Write `numeric_range.sh MIN MAX VALUE...`. MIN and MAX must themselves be integers (may be negative,
optional leading `-`, no leading `+`); each VALUE is checked against `[MIN, MAX]` (inclusive).

For every VALUE, in order, print `VALUE: dentro` or `VALUE: fuera de rango` (a value that is not even
a valid integer counts as `fuera de rango` too, and is never compared numerically). Finally print
`TOTAL: D dentro, F fuera` (D + F = number of VALUEs).

Errors (stderr, wording free; check in this order): fewer than 3 arguments -> usage, exit **1**; MIN
or MAX is not a valid integer -> a message **naming the bad one**, exit **2**; MIN greater than MAX ->
exit **3**. On success (even if some values are out of range) exit 0.
