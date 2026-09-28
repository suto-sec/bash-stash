# 0707 · Owner and group

**Topic:** find · **Difficulty:** ★★☆☆☆ · **Commands:** find -user, -group

In the real system, print sorted, separated by `---`:

1. the entries under `/home` owned by user `luke`, with `-maxdepth 1`
2. the entries under `/var/log` (maxdepth 1) whose group is `adm`
3. the entries under `/home` (maxdepth 1) **not** owned by `root`

---
Write your solution in `answer.sh`, then run `check 0707`.  
To experiment with the same test files the checker uses: `play 0707`.
