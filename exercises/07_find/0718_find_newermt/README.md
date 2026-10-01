# 0718 · Between two dates (-newermt)

**Topic:** find · **Difficulty:** ★★★☆☆ · **Commands:** find -newermt, ! -newermt, stat -c %Y

The photos under `fotos` have modification dates between 2023 and 2025. Print, separated by `---`:

1. the **regular files** modified during **2024**: strictly after `2024-01-01 00:00` and not after
   `2025-01-01 00:00` (`-newermt DATE` means "modified after DATE"; negate it for the upper bound),
   sorted.
2. the path of the **most recently modified** regular file under `fotos` (just one line; there are
   no ties).

Hint for 2: `stat -c '%Y %n'` prints the modification time in seconds followed by the name.
