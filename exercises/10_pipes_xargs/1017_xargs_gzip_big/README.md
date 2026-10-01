# 1017 · Compressing the big logs with xargs -0

**Topic:** Pipes, xargs & command substitution · **Difficulty:** ★★★☆☆ · **Commands:** find -size -print0, xargs -0 -r, gzip

Under the directory `logs` (and its subdirectories) there are log files, some of them with **spaces**
in their names.

1. Compress with `gzip` every **regular file** whose name ends in `.log` and that is **bigger than
   2048 bytes** (`find ... -size +2k`), using `find ... -print0 | xargs -0 gzip`.
   Smaller `.log` files, files with other endings (`.txt`, `.log.1`...) and directories must be left
   untouched.
2. Then print the paths of all the `.gz` files under `logs`, sorted, one per line, as `find logs`
   prints them.

Tip: `xargs -r` (`--no-run-if-empty`) avoids running `gzip` with no arguments when nothing matches
(`gzip` without arguments would compress its stdin).
