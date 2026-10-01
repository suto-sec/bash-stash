# 1333 · copy_pairs.sh: consuming SRC/DST pairs with shift

**Topic:** Script parameters & exit codes · **Difficulty:** ★★★★☆ · **Commands:** shift N, $#, test -e, cp, exit codes

Write `copy_pairs.sh SRC1 DST1 [SRC2 DST2 ...]`: the arguments form pairs, each pair a source file to
copy and its destination. Process the pairs **in order**, two at a time (`shift 2` per pair): for
each pair, copy SRC to DST with `cp` and print `copiado: SRC -> DST`.

Errors (stderr, wording free; check in this order): an **odd** number of arguments -> usage message,
exit **1**; a SRC that does not exist -> a message **naming it**, exit **2** (stop immediately, do
not process the remaining pairs).

If every pair is copied, finally print `TOTAL: N copias` (N = number of pairs) and exit 0.
