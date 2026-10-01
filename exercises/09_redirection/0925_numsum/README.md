# 0925 · numsum.sh (numbers from a file or from stdin)

**Topic:** Redirection: > >> 2> < << <<< · **Difficulty:** ★★★★☆ · **Commands:** exec < file, while read, [[ =~ ]], >&2, $(( ))

Write `numsum.sh`:

```
numsum.sh [FILE]
```

It reads lines from `FILE`, or from its **standard input** if there is no argument or the argument is
`-` (the usual Unix convention). Each non-empty line should be an **integer**: an optional `-` followed
by digits without leading zeros (`0` alone is fine; `007`, `+3`, `1.5`, ` 4` are not). Empty lines are
ignored.

- For every non-empty line that is not an integer, print on **stderr** exactly
  `line <N>: invalid '<line>'` (`N` = line number, counting all lines).
- On stdout print `count: <C>` and `sum: <S>` of the valid integers, and, only if `C > 0`,
  `min: <m>` and `max: <M>` (each on its own line, in this order).

Exit code: 0 if there were no invalid lines, **3** otherwise.
Errors (message on **stderr**): more than one argument → usage, exit **1**; `FILE` is not a
readable regular file → exit **2**.

Hint: `exec < "$FILE"` makes the rest of the script read from the file.
