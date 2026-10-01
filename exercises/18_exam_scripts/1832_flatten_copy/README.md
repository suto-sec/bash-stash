# 1832 · Flattening a source tree into one directory

**Topic:** Exam-style scripts · **Difficulty:** ★★★★☆ · **Commands:** find, sort, cp, basename

Write `flatten_copy.sh SRC DEST`. It copies every **regular file** found anywhere under `SRC`
(recursively) into `DEST`, **flattened**: only the file's basename is used, its subdirectory is
discarded.

Files are processed **in the order of `find SRC -type f | sort`** (sorted by full source path). For
each one: if `DEST` does not yet contain an entry with that basename, copy it there and print
`copied: <source path>`; if it does (either because it already existed before the script ran, or
because an **earlier** file in this same run was copied there), skip it without touching `DEST` and
print `skip: <name> (from <source path>)` to stderr.

If `DEST` does not exist, create it (`mkdir -p`) and print `Directory <DEST> created` on stdout
*before* processing any file. Finally print `Copied N files, skipped M collisions`.

Checks, in this order:
- not exactly 2 arguments: usage on stderr, exit **1**.
- `SRC` does not exist: message on stderr (naming `SRC`), exit **2**.
- `SRC` exists but is not a directory: message on stderr (naming `SRC`), exit **3**.
- `DEST` exists but is not a directory: message on stderr (naming `DEST`), exit **4**.

File and directory names may contain spaces.
