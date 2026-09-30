# 1317 · Reporting a command's exit status

**Topic:** Script parameters & exit codes · **Difficulty:** ★★★☆☆ · **Commands:** "$@", $?, exit N

Write `try.sh command [args...]`. It runs the command given in its arguments (exactly, with `"$@"`),
hiding the command's stdout **and** stderr. Then it prints

- `OK: <command line>` if the command exited with 0
- `FAILED (<code>): <command line>` otherwise

where `<command line>` is all the arguments joined by single spaces (`"$*"`). The script itself must
**exit with the same code as the command** (a command that does not exist gives 127).

With no arguments print `Usage: try.sh command [args...]` on stderr (use `$(basename "$0")`) and
exit **64**.

---
Write your solution in `answer.sh`, then run `check 1317`.  
To experiment with the same test files the checker uses: `play 1317`.
