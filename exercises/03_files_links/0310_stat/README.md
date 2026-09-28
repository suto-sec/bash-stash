# 0310 · File metadata with stat

**Topic:** Files, copies & links · **Difficulty:** ★★☆☆☆ · **Commands:** stat -c

For each of the files `a`, `b` and `c` in the current directory, print a line with:
name, size in bytes, permissions in octal and number of hard links, separated by spaces:

```
a 1532 644 1
b 12 600 2
c 0 755 1
```

Use `stat -c` with the right format sequences (`man stat`).

---
Write your solution in `answer.sh`, then run `check 0310`.  
To experiment with the same test files the checker uses: `play 0310`.
