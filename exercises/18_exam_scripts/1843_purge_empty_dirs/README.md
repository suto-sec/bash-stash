# 1843 · Removing empty directories recursively

**Topic:** Exam-style scripts · **Difficulty:** ★★★★☆ · **Commands:** find -depth -empty, rmdir, mapfile

Write `purge_empty_dirs.sh DIR`. It removes every empty directory under `DIR` (excluding `DIR`
itself), **repeating** until none remain: a directory that becomes empty only after its own empty
subdirectories were removed must also be removed (a directory that still contains a regular file is
never removed, even if all its subdirectories are gone).

Print, **sorted**, the path of every directory removed (the full set, regardless of the order they
were actually removed in), then `Removed N empty directories`.

Checks, in this order:
- not exactly 1 argument: usage on stderr, exit **1**.
- `DIR` does not exist: message on stderr (naming `DIR`), exit **2**.
- `DIR` exists but is not a directory: message on stderr (naming `DIR`), exit **3**.

---
Write your solution in `answer.sh`, then run `check 1843`.  
To experiment with the same test files the checker uses: `play 1843`.
