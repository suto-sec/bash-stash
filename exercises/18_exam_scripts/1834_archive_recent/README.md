# 1834 · Archiving recently modified files

**Topic:** Exam-style scripts · **Difficulty:** ★★★★☆ · **Commands:** find -mtime, tar -czf --null -T -

Write `archive_recent.sh DIR DAYS DEST`. It archives every **regular file** under `DIR`
(recursively) that matches `find DIR -type f -mtime -DAYS` (i.e. modified less than `DAYS` days
ago) into `DEST/recent.tar.gz`, with paths inside the archive **relative to `DIR`**.

If `DEST` does not exist, create it (`mkdir -p`) and print `Created <DEST>` on stdout. Finally print
`Archived N files into <DEST>/recent.tar.gz` (`DEST` printed exactly as given).

Checks, in this order:
- not exactly 3 arguments: usage on stderr, exit **1**.
- `DIR` does not exist: message on stderr (naming `DIR`), exit **2**.
- `DIR` exists but is not a directory: message on stderr (naming `DIR`), exit **3**.
- `DAYS` is not a non-negative integer: message on stderr, exit **4**.
- no file matches: message on stderr, exit **5**, and **no** archive is created (nor is `DEST`).
