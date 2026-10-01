# 1833 · Normalising permissions of shell scripts

**Topic:** Exam-style scripts · **Difficulty:** ★★★★☆ · **Commands:** find -name, stat -c %a, chmod

Write `perm_fix.sh DIR MODE` (`MODE`: octal permission, 3 or 4 digits, like `chmod`). For every
**regular file** ending in `.sh` under `DIR` (recursively) whose current permission bits differ from
`MODE`, set them to `MODE` (`chmod`) and print `fixed: <path>` (sorted by path). Files whose
permissions already equal `MODE` are left untouched and not printed. Finally print
`Fixed N files (already correct: K)`.

Checks, in this order:
- not exactly 2 arguments: usage on stderr, exit **1**.
- `DIR` does not exist: message on stderr (naming `DIR`), exit **2**.
- `DIR` exists but is not a directory: message on stderr (naming `DIR`), exit **3**.
- `MODE` is not 3-4 octal digits: message on stderr, exit **4**.
