# 0747 · audit_scripts.sh: executable scripts, skipping a subtree

**Topic:** find · **Difficulty:** ★★★★☆ · **Commands:** find -prune -o -print, -perm /111, script argument, summary line

Write `audit_scripts.sh`:

```
audit_scripts.sh [directory]
```

Prints, **sorted**, the paths of every **regular file** under `directory` (default: the current
directory) that has **some execute permission** (`-perm /111`) and whose name ends in `.sh`, but
**skips entirely** any subtree rooted at a directory named exactly `vendor` — don't even descend
into it (use `-prune`). A directory called `vendor_old` is **not** `vendor` and must still be
searched. After the list, print exactly:

```
Total: N scripts
```

No argument-count validation is required: default to `.` when no argument is given.
