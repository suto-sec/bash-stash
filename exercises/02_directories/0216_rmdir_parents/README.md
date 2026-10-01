# 0216 · rmdir -p: removing a branch

**Topic:** Directories & navigation · **Difficulty:** ★★★☆☆ · **Commands:** rmdir -p, dirname, test -d, while

The file `leaf.txt` contains the relative path of an **empty** directory, several levels deep
(e.g. `alpha/bravo/charlie/delta`). Some of its ancestors may contain other things (files or other
directories).

1. Remove the leaf and, going up, every ancestor that becomes empty, with **one** `rmdir -p`
   command. `rmdir -p` stops (with an error message) at the first ancestor that is not empty:
   discard that message. Use `rmdir` only (no `rm`).
2. Then, for the path in the file and each of its ancestors (from the longest to the shortest,
   i.e. `a/b/c/d`, `a/b/c`, `a/b`, `a`), print `removed <path>` if it no longer exists or
   `kept <path>` if it is still there.

Hint: `dirname a/b/c` is `a/b`, and `dirname a` is `.`.
