# 0332 · Swapping two files without losing data

**Topic:** Files, copies & links · **Difficulty:** ★★★☆☆ · **Commands:** mv, mktemp

The current directory contains `a.txt` and `b.txt`, each with its own content and its own
permission bits. Using only `mv` (no `cp`, no `cat`), make `a.txt`'s content become what `b.txt`
had, and `b.txt`'s content become what `a.txt` had.

`mv a.txt b.txt` directly would overwrite and lose `b.txt`'s original content, so route one of the
files through a third, disposable name first — get one with `mktemp` in the current directory — to
do a proper three-way rotation. Remember that a permission mode belongs to the **inode**, not to the
name: `mv` carries it along with the data, so after the swap don't be surprised that each name now
also carries the *other* file's original permissions. Nothing is printed.

---
Write your solution in `answer.sh`, then run `check 0332`.  
To experiment with the same test files the checker uses: `play 0332`.
