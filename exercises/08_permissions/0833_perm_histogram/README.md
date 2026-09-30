# 0833 · perm_histogram.sh: a histogram of file modes

**Topic:** Permissions, chmod, umask, chown · **Difficulty:** ★★★★☆ · **Commands:** find -type f -printf %m, sort, exit codes

Write `perm_histogram.sh`:

```
perm_histogram.sh DIR
```

Under `DIR` (recursively), group the **regular files** by their exact octal mode (the value `chmod`
would take, e.g. `644`; symbolic links and directories are not counted). Print one line per distinct
mode, **sorted by mode ascending** (as a string, e.g. `600` before `644` before `755`):

```
MODE: N
```

Then print `Total: T files` (`T` = total regular files, the sum over all modes). If `DIR` has no
regular files, print only `Total: 0 files`.

Errors (message on stderr): not exactly 1 argument → usage, exit **1**; `DIR` is not a directory →
exit **2** (message includes `DIR`).

---
Write your solution in `answer.sh`, then run `check 0833`.  
To experiment with the same test files the checker uses: `play 0833`.
