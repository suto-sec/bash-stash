# 1837 · Building a symlink farm for .conf files

**Topic:** Exam-style scripts · **Difficulty:** ★★★★☆ · **Commands:** find -name, ln -s, readlink

Write `linkfarm.sh SRC DEST`. For every **regular file** ending in `.conf` under `SRC`
(recursively), create in `DEST` (flat, not recursive) a **symbolic link** — with an **absolute**
target — named after the file's basename, pointing to it.

Files are processed **in the order of `find SRC -type f -name '*.conf' | sort`**. For each one: if
`DEST` does not yet contain an entry with that basename, create the link and print
`linked: <source path>`; otherwise (pre-existing, or created by an earlier file this run) skip it
and print `skip: <name>` to stderr.

If `DEST` does not exist, create it (`mkdir -p`) and print `Directory <DEST> created` on stdout
before processing any file. Finally print `Linked N files, skipped M collisions`.

Checks, in this order:
- not exactly 2 arguments: usage on stderr, exit **1**.
- `SRC` does not exist: message on stderr (naming `SRC`), exit **2**.
- `SRC` exists but is not a directory: message on stderr (naming `SRC`), exit **3**.
- `DEST` exists but is not a directory: message on stderr (naming `DEST`), exit **4**.
