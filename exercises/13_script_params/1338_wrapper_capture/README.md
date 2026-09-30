# 1338 · wrapper_capture.sh: prefixing a command's captured output

**Topic:** Script parameters & exit codes · **Difficulty:** ★★★★☆ · **Commands:** "$@", $(...), $?, while read

Write `wrapper_capture.sh CMD [ARGS...]`: run `CMD ARGS...`, capture its standard output (its stderr
is discarded) and print:

```
salida:
> line1
> line2
...
exit: CODE
```

(one `> ` per captured line, in order; if it produced no output at all, print nothing between
`salida:` and the `exit:` line). CODE is the command's exit code.

With no arguments, print a usage message on stderr and exit 1 (without running anything). Otherwise
the script's own exit code is always 0, regardless of CODE.

---
Write your solution in `answer.sh`, then run `check 1338`.  
To experiment with the same test files the checker uses: `play 1338`.
