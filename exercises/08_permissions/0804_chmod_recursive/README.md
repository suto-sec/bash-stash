# 0804 · Recursive chmod and capital X

**Topic:** Permissions, chmod, umask, chown · **Difficulty:** ★★★☆☆ · **Commands:** chmod -R, X

The tree `web` has files and directories with messy permissions. With **one** `chmod -R` command:

- user: read + write on everything, execute **only** on directories and on files that already
  have execute for someone (that's what capital `X` does)
- group and others: read on everything, execute with the same `X` rule
- nobody except the user can write

(Tip: `chmod -R u=rwX,go=rX web`.)

---
Write your solution in `answer.sh`, then run `check 0804`.  
To experiment with the same test files the checker uses: `play 0804`.
