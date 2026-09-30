# 1336 · last_success.sh: tracking the last file that could be read

**Topic:** Script parameters & exit codes · **Difficulty:** ★★★★☆ · **Commands:** for, test -r, exit codes

Write `last_success.sh FILE...`: for every argument, in order, try to read it (`cat FILE > /dev/null
2>&1`) and print `OK: FILE` or `FAIL: FILE`. Keep the **1-based position** of the last one that
succeeded (`ok_pos`; `0` if none did). Finally print `ultimo_ok: P de N` (P = that position, N = total
arguments).

With no arguments, print a usage message on stderr and exit 1 (without printing anything else).
Otherwise always exit 0, even if every file failed.

---
Write your solution in `answer.sh`, then run `check 1336`.  
To experiment with the same test files the checker uses: `play 1336`.
