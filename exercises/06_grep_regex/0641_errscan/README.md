# 0641 · errscan.sh: scanning several files for a pattern

**Topic:** grep & regular expressions · **Difficulty:** ★★★★☆ · **Commands:** grep -E (several files), script arguments (variadic)

Write `errscan.sh`:

```
errscan.sh FILE...
```

Takes **one or more** file names. Using a **single** `grep -E` call over all of them, print every
line that matches `ERROR` or `CRITICAL` (exact case), prefixed with its file name and a colon
exactly as `grep` does automatically when given more than one file (in the order the files are
given on the command line). Then print:

```
Total: N
```

where `N` is the number of matching lines over all files.

Errors (message on **stderr**, nothing on stdout):

- no arguments: error and usage, exit **1**
- any argument is not a readable regular file: message naming it, exit **2** (check the arguments
  left to right; report the first bad one)
