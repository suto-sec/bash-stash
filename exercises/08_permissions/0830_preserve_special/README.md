# 0830 · preserve_special.sh: chmod without erasing setuid/setgid/sticky

**Topic:** Permissions, chmod, umask, chown · **Difficulty:** ★★★★☆ · **Commands:** stat -c %a, chmod, exit codes

`chmod 750 FILE` looks harmless, but if `FILE` already had its setuid, setgid or sticky bit set,
**plain octal `chmod` with only 3 digits silently clears those special bits** — `stat -c %a` prints
`4750` before and `750` after. Write `preserve_special.sh`:

```
preserve_special.sh FILE MODE
```

`MODE` is always exactly **3** octal digits (the base `rwx` bits, no special-bit digit — reject
anything else). Change `FILE`'s base permission bits to `MODE` while **keeping** whatever special
bits (setuid/setgid/sticky) it already had, by computing the correct 4-digit mode yourself before
calling `chmod` (instead of calling `chmod MODE FILE` directly, which would erase them). Print
`OLD -> NEW`, where `OLD` and `NEW` are exactly what `stat -c %a FILE` shows before and after (3
digits when there are no special bits, 4 when there are).

Errors (message on stderr): not exactly 2 arguments → usage, exit **1**; `FILE` is not a regular file
→ exit **2** (message includes `FILE`); `MODE` is not exactly 3 octal digits → exit **3** (message
includes `MODE`).
