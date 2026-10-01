# 0647 · Anchors ^ and $

**Topic:** grep & regular expressions · **Difficulty:** ★☆☆☆☆ · **Commands:** grep ^, $

In a pattern, `^` means "at the start of the line" and `$` means "at the end of the line". Put the pattern in single quotes so the shell does not touch the `$`.

For the file `nombres.txt`, print, with a line `---` in between:

1. the lines that **start** with `a`
2. the lines that **end** with `z`

Example: if `nombres.txt` contains `adan`, `beatriz`, `luz`, `raul`, the output is:

```
adan
---
beatriz
luz
```

Hint: `grep '^a' file` and `grep 'z$' file`.

---
Write your solution in `answer.sh`, then run `check 0647`.  
To experiment with the same test files the checker uses: `play 0647`.
