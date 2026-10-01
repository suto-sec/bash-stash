# 1815 · One-way directory sync

**Topic:** Exam-style scripts · **Difficulty:** ★★★★★ · **Commands:** find, test -nt, cp -p, mkdir -p, ${f#prefix}

Write `sync.sh SRC DST` that makes `DST` contain every regular file of `SRC` (recursively, same
relative paths): a file is copied if it is **missing** in `DST` or the one in `SRC` is **newer**
(`-nt`). Copies must **preserve** modification times (`cp -p`), so a second run copies nothing.
Files that exist only in `DST` are left alone.

If `DST` doesn't exist, create it and print `Created <DST>`. Print `copied: <relative path>` for each
copied file (sorted), then `N files copied`.

- not exactly 2 arguments: usage on stderr, exit 1
- `SRC` not a directory: stderr, exit 2
