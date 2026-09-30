# 0828 · umask_audit.sh (files more open than the umask)

**Topic:** Permissions, chmod, umask, chown · **Difficulty:** ★★★★☆ · **Commands:** $(( 8#... & ... )), printf %03o, find, chmod, options, exit codes

Write:

```
umask_audit.sh [-f] UMASK DIR
```

A file or directory "exceeds" a umask when it has some permission bit that the umask would remove
(`mode & umask` is not 0). For every regular file and directory **under** `DIR` (recursively, not `DIR`
itself; symbolic links ignored), sorted by path (as `find DIR` prints them, sorted with `sort`), that
exceeds `UMASK`:

- without `-f`: print `<path>: <mode> (extra <bits>)`, where `<bits>` = `mode & umask`
- with `-f`: remove those bits (`mode & ~umask`) and print `<path>: <mode> -> <new mode>`

All modes are printed as **3 octal digits** (`printf '%03o'`). Finally print
`N of M entries exceed umask UMASK` (`UMASK` as given; `M` = entries examined).

`UMASK` is 3 or 4 octal digits whose user digit is `0` (`022`, `0027`, `077`...). Errors (message on
stderr), checked in this order:

- wrong arguments (not `[-f] UMASK DIR`, e.g. an unknown option or a wrong count) → usage, exit **1**
- `DIR` is not a directory → exit **2**
- `UMASK` is not valid → exit **3**, message including it

---
Write your solution in `answer.sh`, then run `check 0828`.  
To experiment with the same test files the checker uses: `play 0828`.
