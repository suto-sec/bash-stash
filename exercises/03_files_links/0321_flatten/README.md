# 0321 · Flattening a directory

**Topic:** Files, copies & links · **Difficulty:** ★★★☆☆ · **Commands:** mv, basename, dirname, rmdir

The directory `caos` contains some regular files and some subdirectories (names may contain spaces).
Each subdirectory contains only regular files (no deeper levels), or nothing at all.

1. Move every file `caos/D/F` to `caos/D_F` (the subdirectory name, an underscore, the file name).
2. Remove all the subdirectories, which are now empty (use `rmdir`, not `rm -r`).
3. Print `N files moved`.

Files that were already directly in `caos` stay where they are.

---
Write your solution in `answer.sh`, then run `check 0321`.  
To experiment with the same test files the checker uses: `play 0321`.
