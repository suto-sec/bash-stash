# 0230 · ls: -a and -l

**Topic:** Directories & navigation · **Difficulty:** ★☆☆☆☆ · **Commands:** ls -a, ls -l

The directory `d` contains a normal file and a hidden file (a name that starts with a dot).

Print, separated by a line `---`:

1. the content of `d` with `ls -a`, which shows **all** entries, hidden ones included, and also `.` (this directory) and `..` (the parent directory)
2. the content of `d` in long format with `ls -l`: one line per entry with permissions, owner, size and date (the checker ignores the date)

Expected output (the names and sizes change on every run):

```
.
..
.ayuda
notas
---
total 0
-rw-r--r-- 1 alumno alumno 0 Oct  1 10:00 notas
```

Hint: `ls -a dir` and `ls -l dir`. Hidden files are not shown by `ls -l` unless you add `-a`.

---
Write your solution in `answer.sh`, then run `check 0230`.  
To experiment with the same test files the checker uses: `play 0230`.
