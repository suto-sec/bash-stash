# 0224 · mirror.sh: copying only the directory structure

**Topic:** Directories & navigation · **Difficulty:** ★★★★☆ · **Commands:** cd && pwd -P, find -type d, mkdir -p, dirname, exit codes

Write `mirror.sh`:

```
mirror.sh SRC DEST
```

It creates `DEST` and, inside it, every directory that exists under `SRC` (recursively, hidden ones
included) with the same relative paths, but **no files**. For example, if `SRC` contains
`a/b/file.txt` and `c/`, then `DEST/a/b` and `DEST/c` are created.

Print `Mirrored N directories from SRC into DEST` (N = number of directories under `SRC`, not counting
`SRC` itself; `SRC` and `DEST` exactly as given).

Errors (message on stderr, nothing created), checked in this order:

- not exactly 2 arguments: usage, exit **1**
- `SRC` is not a directory: exit **2** (mention it)
- `DEST` already exists, or the directory that would contain it (`dirname DEST`) does not exist: exit
  **3** (mention `DEST`)
- `DEST` would be **inside** `SRC` (its parent directory, resolved to a physical absolute path, is
  `SRC` or below `SRC`, also resolved; e.g. `mirror.sh a a/copy` or `mirror.sh a ./a/b/../copy`):
  exit **4**

Careful: `SRC` and `DEST` may be relative paths, and may contain spaces.
