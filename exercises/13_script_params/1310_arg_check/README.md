# 1310 · Checking the number of arguments

**Topic:** Script parameters & exit codes · **Difficulty:** ★★☆☆☆ · **Commands:** $#, test, >&2, exit

The script (installed as `copia.sh`) needs **exactly 2** arguments: `source` and `destination`.

- wrong number of arguments: print on stderr `Usage: copia.sh <source> <destination>` and exit **1**
- `source` doesn't exist: print on stderr `Error: <source> does not exist` and exit **2**
- otherwise copy `source` to `destination` and print `Copied <source> to <destination>`

---
Write your solution in `answer.sh`, then run `check 1310`.  
To experiment with the same test files the checker uses: `play 1310`.
