# 0831 · stickygap.sh: world-writable directories missing the sticky bit

**Topic:** Permissions, chmod, umask, chown · **Difficulty:** ★★★★☆ · **Commands:** find -perm -0002 ! -perm -1000, chmod +t, options, exit codes

A directory that is writable by **others** but does **not** have the sticky bit is dangerous: any
user can delete or rename any other user's files inside it (that's exactly why `/tmp` has mode
`1777`, not `0777`). Write `stickygap.sh`:

```
stickygap.sh [-f] DIR
```

Find every **directory** under `DIR` (recursively, `DIR` itself included) that is writable by others
(`-perm -0002`) but does **not** have the sticky bit set (`! -perm -1000`). Sorted by path (as
`find DIR` prints it, sorted with `sort`):

- without `-f`: print `<path>: <mode>` (mode as `stat -c %a`)
- with `-f`: add the sticky bit (`chmod +t`) and print `<path>: <mode> -> <new mode>`

Finally print `N directories found` (or, with `-f`, `N directories fixed`).

Exit codes: **0** if none were found (or `-f` fixed them all); **1** if some were found and `-f` was
not given; **2** wrong usage — anything other than an optional `-f` followed by exactly one directory
argument (usage on stderr); **3** if `DIR` is not a directory (message includes `DIR`).

---
Write your solution in `answer.sh`, then run `check 0831`.  
To experiment with the same test files the checker uses: `play 0831`.
