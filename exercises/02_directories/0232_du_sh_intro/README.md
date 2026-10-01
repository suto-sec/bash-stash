# 0232 · du -sh: total size, human readable

**Topic:** Directories & navigation · **Difficulty:** ★☆☆☆☆ · **Commands:** du -sh

The directory `datos` contains files of different sizes, and a subdirectory with more files.

Print the **total** size of `datos` in a human readable form (`K`, `M`...) with a single `du -sh` command: `-s` prints only the total, `-h` means human readable.

Expected output (the size changes on every run):

```
24K	datos
```

Hint: `du -sh dir`
