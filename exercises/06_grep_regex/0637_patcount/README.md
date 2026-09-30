# 0637 · patcount.sh (counting fixed-string patterns)

**Topic:** grep & regular expressions · **Difficulty:** ★★★★☆ · **Commands:** grep -c -i -F -e, while read, [[ == \#* ]]

Write `patcount.sh`:

```
patcount.sh PATTERNS FILE
```

`PATTERNS` contains one pattern per line; empty lines and lines starting with `#` are ignored.
Every pattern is **plain text**, not a regex (`1.2.3.4` must not match `1x2x3x4`, `[error]` is
literally those 7 characters, `-v` is a pattern, not an option) and is searched **case-insensitively**.

For each pattern, in the order of the file (repeated patterns are printed again), print

```
<pattern>: <number of lines of FILE that contain it>
```

and finally `<M> of <P> patterns found` (`P` patterns processed, `M` of them with at least one line).
Exit code: 0 if `M > 0`, **4** if no pattern was found (after printing everything).

Errors (message on **stderr**): not exactly 2 arguments → usage, exit **1**; `PATTERNS` not
readable → exit **2**; `FILE` not readable → exit **3** (mention the file in both cases).

---
Write your solution in `answer.sh`, then run `check 0637`.  
To experiment with the same test files the checker uses: `play 0637`.
