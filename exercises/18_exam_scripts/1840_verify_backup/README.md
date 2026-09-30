# 1840 · Verifying a backup copy

**Topic:** Exam-style scripts · **Difficulty:** ★★★★☆ · **Commands:** find, cmp -s

Write `verify_backup.sh SRC DEST`. For every **regular file** under `SRC` (recursively), sorted by
its path **relative to `SRC`**, compare it to the file at the same relative path in `DEST`:

- missing in `DEST`: print `MISSING <relpath>`
- present in `DEST` but not a regular file, or a regular file with different content (`cmp -s`):
  print `DIFF <relpath>`
- present and byte-identical: print `OK <relpath>`

Finally print `SRC has N files: <ok> ok, <diff> differing, <missing> missing`.

Checks, in this order:
- not exactly 2 arguments: usage on stderr, exit **1**.
- `SRC` does not exist: message on stderr (naming `SRC`), exit **2**.
- `SRC` exists but is not a directory: message on stderr (naming `SRC`), exit **3**.
- `DEST` does not exist: message on stderr (naming `DEST`), exit **4**.
- `DEST` exists but is not a directory: message on stderr (naming `DEST`), exit **5**.

---
Write your solution in `answer.sh`, then run `check 1840`.  
To experiment with the same test files the checker uses: `play 1840`.
