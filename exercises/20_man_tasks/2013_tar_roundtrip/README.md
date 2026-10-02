# 2013 · Pack it and restore it elsewhere

**Topic:** Exam tasks with the manual · **Difficulty:** ★★★☆☆ · **Commands:** tar, mkdir

The folder `datos` has files and subfolders.

1. Create the compressed archive `copia.tgz` that contains the folder `datos`, so that the names inside start with `datos/`.
2. Create the folder `restaurado` and extract the archive **into it** (without leaving the current folder), so that `restaurado/datos/...` exists.

Do it with `tar` only (not `cp`). The options for creating, listing, extracting, compressing with gzip and for changing the target folder are all in `man tar`.
