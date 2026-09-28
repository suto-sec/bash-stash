# 1501 · Counting loops

**Topic:** Loops: for, while, until, read · **Difficulty:** ★☆☆☆☆ · **Commands:** for in {1..N}, seq, for (( ))

The script receives N. Print:

1. the numbers 1..N separated by spaces on one line (using a `for` loop and `echo -n`, then a newline)
2. the numbers N down to 1, one per line (`seq N -1 1` or a C-style for)
3. `Iteracion numero K` for K = 1..N (like `script_for.sh` in `~/scripts.tgz`)

Note: `{1..$N}` does **not** work with variables; use `seq` or `for ((...))`.

---
Write your solution in `answer.sh`, then run `check 1501`.  
To experiment with the same test files the checker uses: `play 1501`.
