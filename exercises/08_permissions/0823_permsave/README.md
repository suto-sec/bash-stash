# 0823 · permsave.sh (saving and restoring permissions)

**Topic:** Permissions, chmod, umask, chown · **Difficulty:** ★★★★☆ · **Commands:** find, stat -c %a, chmod, while read, case, exit codes

Write a tool to save the permissions of a tree and restore them later:

```
permsave.sh save DIR FILE
permsave.sh restore DIR FILE
```

**save**: write into `FILE` one line `MODE PATH` for every regular file and directory **under** `DIR`
(recursively, not `DIR` itself; symbolic links ignored), where `MODE` is `stat -c %a` and `PATH` is the
path relative to `DIR` without a leading `./` (e.g. `644 sub/a b.txt`). Lines are ordered by `PATH`, in
the order `sort` gives to the paths. Then print `Saved N entries to FILE` (`FILE` as given).

**restore**: read `FILE` line by line; for each `MODE PATH`:

- if `DIR/PATH` does not exist: print `missing PATH` on **stderr**
- otherwise, if its current mode differs from `MODE`, `chmod` it and print `restored PATH: OLD -> MODE`

Then print `Restored N entries, M missing` (`N` = entries whose mode was changed).

Errors (message on stderr), checked in this order: not exactly 3 arguments → exit **1**; first argument
neither `save` nor `restore` → exit **2**; `DIR` is not a directory → exit **3**; for `restore`, `FILE`
is not a readable regular file → exit **4**. Names may contain spaces (not newlines).

---
Write your solution in `answer.sh`, then run `check 0823`.  
To experiment with the same test files the checker uses: `play 0823`.
