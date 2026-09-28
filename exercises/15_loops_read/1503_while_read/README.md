# 1503 · Reading a file line by line

**Topic:** Loops: for, while, until, read · **Difficulty:** ★★☆☆☆ · **Commands:** while read -r, IFS=

Print every line of `entrada.txt` prefixed with its number, like a classic "number the lines" child process:

```
1: first line
2:    second line keeps its leading spaces
```

Use `while IFS= read -r line; do ...; done < entrada.txt` (think: why `IFS=` and why `-r`?).
The last line of the file may **not** end with a newline: it must still be printed.

---
Write your solution in `answer.sh`, then run `check 1503`.  
To experiment with the same test files the checker uses: `play 1503`.
