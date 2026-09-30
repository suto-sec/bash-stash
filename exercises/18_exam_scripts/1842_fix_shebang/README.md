# 1842 · Fixing missing or wrong shebang lines

**Topic:** Exam-style scripts · **Difficulty:** ★★★★☆ · **Commands:** head -n 1, mv, chmod

Write `fix_shebang.sh DIR`. For every **regular file** ending in `.sh` under `DIR` (recursively,
sorted by path): if its first line is **not exactly** `#!/bin/bash` (an empty file has no first
line, so it counts as not matching), prepend a new first line `#!/bin/bash` before the file's
existing content, **preserving the file's permissions**, and print `fixed: <path>`. Files that
already start with exactly that line are left untouched and not printed. Finally print
`Fixed N of M scripts` (M = total `.sh` files found).

Checks, in this order:
- not exactly 1 argument: usage on stderr, exit **1**.
- `DIR` does not exist: message on stderr (naming `DIR`), exit **2**.
- `DIR` exists but is not a directory: message on stderr (naming `DIR`), exit **3**.

---
Write your solution in `answer.sh`, then run `check 1842`.  
To experiment with the same test files the checker uses: `play 1842`.
