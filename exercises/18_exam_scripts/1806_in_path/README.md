# 1806 · Where is it in $PATH?

**Topic:** Exam-style scripts · **Difficulty:** ★★★☆☆ · **Commands:** IFS=:, for, test -e -x

Write `inpath.sh NAME` that looks for `NAME` in every directory of `$PATH`, **in order**, and for
each match prints `DIR/NAME (executable)` or `DIR/NAME (not executable)`.

- no argument (or more than one): usage on stderr, exit 2
- not found anywhere: `NAME not found in PATH` on stderr, exit 1
- directories of `$PATH` that don't exist are skipped silently
