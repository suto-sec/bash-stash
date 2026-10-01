# 1816 · Log rotation

**Topic:** Exam-style scripts · **Difficulty:** ★★★★☆ · **Commands:** mv, gzip, for (( )), test -e

Write `rota.sh LOGFILE [KEEP]` (KEEP default 3) that rotates a log like `logrotate` does:

1. delete `LOGFILE.KEEP.gz` if it exists
2. for i = KEEP-1 down to 1: rename `LOGFILE.i.gz` → `LOGFILE.(i+1).gz` (if it exists)
3. compress the current `LOGFILE` into `LOGFILE.1.gz` (`gzip -c LOGFILE > LOGFILE.1.gz`)
4. leave an **empty** `LOGFILE` (same name) in place

Print `Rotated <LOGFILE> (keeping KEEP)`.

- wrong number of arguments: usage on stderr, exit 1
- LOGFILE is not a regular file: stderr, exit 2
- KEEP not an integer ≥ 1: stderr, exit 3
