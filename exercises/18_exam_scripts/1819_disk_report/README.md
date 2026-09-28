# 1819 · Disk usage report with percentages

**Topic:** Exam-style scripts · **Difficulty:** ★★★★☆ · **Commands:** du -sk, sort -n, head, $(( ))

Write `espacio.sh [DIR] [N]` (defaults: current directory, 3) that prints the `N` biggest
**subdirectories directly inside** `DIR` according to `du -sk`, biggest first (ties: name), as:

```
<KB> KB <PCT>% <name>
```

where PCT = KB·100 / (`du -sk DIR` total), integer division, and name is the subdirectory name (no path).
Last line: `Total: <KB> KB`. Validation: DIR not a directory → stderr, exit 1; N not a positive integer
→ stderr, exit 2.

---
Write your solution in `answer.sh`, then run `check 1819`.  
To experiment with the same test files the checker uses: `play 1819`.
