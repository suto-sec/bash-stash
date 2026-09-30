# 1319 · The exit code as a counter

**Topic:** Script parameters & exit codes · **Difficulty:** ★★★☆☆ · **Commands:** test -e, exit $n, >&2

Write `need.sh file...`. For every argument that does **not** exist (anything that exists counts:
files, directories...), print `missing: <name>` on **stderr**. At the end print on stdout
`P of N present` (P existing, N arguments).

The **exit code** of the script must be the number of missing arguments (0 when all exist).

With no arguments print `Usage: need.sh file...` on stderr (use `$(basename "$0")`) and exit **255**.

---
Write your solution in `answer.sh`, then run `check 1319`.  
To experiment with the same test files the checker uses: `play 1319`.
