# 1822 · Log summary with error handling

**Topic:** Exam-style scripts · **Difficulty:** ★★★★☆ · **Commands:** find, grep -ci, test -r, exit codes

Write `resumen.sh [DIR]` (default: current directory) that, for every regular `*.log` file under `DIR`
(sorted by path), prints:

```
<path>: <L> lines, <E> errors, <W> warnings
```

where E = lines containing `error` (any case) and W = lines containing `warn` (any case).
Unreadable files: print `cannot read <path>` on **stderr**, skip them and remember it.
Finally print `TOTAL: <files> files, <L> lines, <E> errors, <W> warnings` (only readable files count).
Exit code: 0 if all files were readable, **4** otherwise. Not a directory: stderr, exit 1.
