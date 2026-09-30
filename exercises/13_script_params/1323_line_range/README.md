# 1323 · lines.sh: printing a range of lines

**Topic:** Script parameters & exit codes · **Difficulty:** ★★★★☆ · **Commands:** ${3:-default}, test -f -r, [[ =~ ]], while read, exit codes

Write `lines.sh`:

```
lines.sh file start [end]
```

It prints lines `start` to `end` (both included) of `file`, each as `N: text` (N = line number,
text exactly as in the file, including leading spaces and backslashes). `end` defaults to the last
line; an `end` bigger than the number of lines is the same as the last line; a `start` bigger than
the number of lines prints no lines (that is not an error). At the end print

```
Printed K of T lines of <file>
```

(K lines printed, T = total lines of the file, `<file>` as given).

Errors, checked in this order (message on **stderr**, wording free, nothing on stdout):

| error | exit |
|-------|------|
| not 2 or 3 arguments (show the usage) | 1 |
| `file` is not a readable regular file (name it) | 2 |
| `start` or `end` (if given) is not a positive integer (digits, not starting with 0) (name it) | 3 |
| `end` is given and `start` > `end` | 4 |

---
Write your solution in `answer.sh`, then run `check 1323`.  
To experiment with the same test files the checker uses: `play 1323`.
