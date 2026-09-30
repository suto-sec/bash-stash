# 0749 · depth_report.sh: direct vs nested files

**Topic:** find · **Difficulty:** ★★★★☆ · **Commands:** find -mindepth, -maxdepth, -type f, script argument

Write `depth_report.sh`:

```
depth_report.sh [directory]
```

Under `directory` (default: the current directory), count **regular files** whose name does
**not** start with `.`:

- those directly inside `directory` (depth 1)
- those **nested** two or more levels down (depth ≥ 2)

Print exactly two lines:

```
Directos: A
Anidados: B
```

---
Write your solution in `answer.sh`, then run `check 0749`.  
To experiment with the same test files the checker uses: `play 0749`.
