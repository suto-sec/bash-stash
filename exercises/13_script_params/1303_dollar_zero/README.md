# 1303 · $0 and usage messages

**Topic:** Script parameters & exit codes · **Difficulty:** ★☆☆☆☆ · **Commands:** $0, basename, exit

The script is installed as `mitool.sh`. If it receives **no** arguments, print on **stderr**:

```
Usage: mitool.sh <file>...
```

(use `$(basename "$0")`, never hard-code the name) and exit with code `1`.
Otherwise, print `OK: N files` (N = number of arguments) and exit `0`.

---
Write your solution in `answer.sh`, then run `check 1303`.  
To experiment with the same test files the checker uses: `play 1303`.
