# 0330 · bigmove.sh (moving the big files away)

**Topic:** Files, copies & links · **Difficulty:** ★★★★☆ · **Commands:** stat -c %s, mv, sort -n, mkdir -p, [[ =~ ]], exit codes

Write:

```
bigmove.sh DIR SIZE DEST
```

It moves every **regular file** directly inside `DIR` (not symbolic links, not directories, hidden files
ignored) whose size is **strictly greater** than `SIZE` bytes (`stat -c %s`) into the directory `DEST`.

- If `DEST` does not exist, create it (with parents) and print `Created <DEST>` first.
- If a file with the same name already exists in `DEST`, the file is **not** moved: print
  `<name> already exists in <DEST>` on **stderr**, and don't count it.
- For each file moved print `<size> <name>` (name without directory), ordered by size **descending**,
  ties by name as `sort` orders them.
- Finally print `Moved N files (B bytes)`. Exit code 0 (even if some file was skipped).

Errors (message on stderr):

- not exactly 3 arguments → usage, exit **1**
- `DIR` is not a directory → exit **2**
- `SIZE` is not a non-negative integer (digits only) → exit **3**
- `DEST` exists but is not a directory → exit **4**

Names may contain spaces (but not tabs or newlines).
