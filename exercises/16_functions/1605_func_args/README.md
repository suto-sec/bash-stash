# 1605 · Function arguments vs script arguments

**Topic:** Functions · **Difficulty:** ★★☆☆☆ · **Commands:** $1 $# "$@" inside functions

Write a function `info` that prints `func got N args: ...` (its `$#` and `$*`). Then:

1. print `script got N args: ...`
2. call `info` with **no** arguments
3. call `info` with the script's arguments **reversed** (build the reversed list in a loop)
4. call `info "$@"` and `info "$*"` (see the difference in N)

---
Write your solution in `answer.sh`, then run `check 1605`.  
To experiment with the same test files the checker uses: `play 1605`.
