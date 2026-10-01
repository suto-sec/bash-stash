# 1618 · potencia.sh: recursive power and digit sum

**Topic:** Functions · **Difficulty:** ★★★★☆ · **Commands:** recursion, $(func), [[ =~ ]], exit codes

Write `potencia.sh BASE EXP`. Using a **recursive** function `potencia B E` (returns the result
with `echo`/`$( )`, since it may not fit in 0-255), compute `BASE` raised to `EXP` (both integers,
`EXP >= 0`). Using a second recursive function `suma_digitos N` (adds the decimal digits of a
non-negative integer, one at a time, the same way), compute the digit sum of `|BASE^EXP|`.

Print exactly:

```
BASE^EXP = R
digit sum of |R|: D
```

Validate before computing (message on **stderr**, wording free but naming the offending value
when there is one; checked in this order):

| situation | exit |
|-----------|------|
| not exactly 2 arguments (show the usage) | 1 |
| BASE is not a valid integer | 2 |
| EXP is not a valid non-negative integer | 3 |
| EXP > 15 (keeps the recursion shallow) | 4 |
