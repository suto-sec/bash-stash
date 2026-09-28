# 0611 · Context lines

**Topic:** grep & regular expressions · **Difficulty:** ★★☆☆☆ · **Commands:** grep -A, -B, -C

In `server.log`, the lines containing `PANIC` are important. Print every `PANIC` line together with
the **2 lines before** it and **1 line after** it (as grep prints it, including `--` separators).

---
Write your solution in `answer.sh`, then run `check 0611`.  
To experiment with the same test files the checker uses: `play 0611`.
