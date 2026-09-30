# 1315 · Arguments in reverse order

**Topic:** Script parameters & exit codes · **Difficulty:** ★★★☆☆ · **Commands:** $#, ${!i}, for (( ))

Print the arguments in **reverse** order, one per line, each preceded by its original position:
`N: argument`. Arguments may contain spaces or be empty.

With no arguments print `no arguments`.

Do it with a counting loop from `$#` down to 1 and **indirect expansion** (`${!i}` is the value of
the parameter whose name/number is stored in `i`). Don't use `tac` or `sort`.

Example: `script.sh a "b c"` prints `2: b c` and then `1: a`.

---
Write your solution in `answer.sh`, then run `check 1315`.  
To experiment with the same test files the checker uses: `play 1315`.
