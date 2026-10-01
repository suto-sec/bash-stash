# 1024 · Files containing both words

**Topic:** Pipes, xargs & command substitution · **Difficulty:** ★★★☆☆ · **Commands:** grep -rlZ, xargs -0 grep -l, sort

`words.txt` contains two words, one per line. Print, sorted, the regular files under `notes`
(recursively) that contain **both** words (case-sensitive, anywhere in the file, possibly in
different lines), as `grep -r` prints their paths. Then print `N files contain both`.

Names may contain spaces: chain the searches with `grep -rlZ W1 notes | xargs -0 grep -l W2`
(`-Z` ends every name with a NUL byte, like `find -print0`).
