# 1318 · Rebuilding the positional parameters with set --

**Topic:** Script parameters & exit codes · **Difficulty:** ★★★☆☆ · **Commands:** set --, IFS, $#

Write `fields.sh text [separator]`. It splits `text` using `separator` (a single character, default
`:`) by setting `IFS` to it and running `set -- $text` (unquoted on purpose). Then it prints the new
number of positional parameters and each of them:

```
N fields
1: first
2: second
...
```

The split must be exactly the one `set -- $text` performs with that `IFS` (e.g. with `:` an empty
field between two separators counts, a trailing separator does not add a field, and with a space as
separator runs of spaces count as one). The text contains no wildcard characters.

Errors (stderr, exact text): no arguments or more than 2 → `Usage: fields.sh text [separator]`
(use `$(basename "$0")`), exit **1**; separator that is not exactly one character →
`Invalid separator`, exit **2**.
