# 0740 · Combining type, name, size and mtime

**Topic:** find · **Difficulty:** ★★★☆☆ · **Commands:** find -type f, -iname, -size, -mtime

Under `var/log`, print **sorted** the regular files whose name ends in `.log` (any case: use `-iname`)
that are **larger than 5 KiB** (`-size +5k`) **and** were **last modified more than 14 days ago**
(`-mtime +14`). All three conditions must hold at the same time — this is a single `find` with four
predicates ANDed together (`-type`, `-iname`, `-size`, `-mtime`).

---
Write your solution in `answer.sh`, then run `check 0740`.  
To experiment with the same test files the checker uses: `play 0740`.
