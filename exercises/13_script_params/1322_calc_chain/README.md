# 1322 · calc.sh: a left-to-right calculator

**Topic:** Script parameters & exit codes · **Difficulty:** ★★★★☆ · **Commands:** shift 2, $#, [[ =~ ]], $(( )), exit codes

Write `calc.sh`:

```
calc.sh n1 [op n2]...
```

It evaluates the expression **from left to right** (no operator precedence) with integer arithmetic.
Operators: `+`, `-`, `x` (multiplication; `*` would be expanded by the shell), `/` (integer division,
truncating like `$(( ))`), `%` (remainder). An operand is an integer: an optional `-` followed by `0`
or by digits not starting with `0` (so `08` is **not** valid).

For every operator print one line `left op right = result`, where `left` is the value accumulated so
far, and finally `Result: R`. Example: `calc.sh 3 + 4 x 2` prints

```
3 + 4 = 7
7 x 2 = 14
Result: 14
```

`calc.sh 7` just prints `Result: 7`.

**Validate every argument before computing anything** (nothing on stdout when there is an error):

| error | exit |
|-------|------|
| no arguments, or an even number of arguments: message with the usage | 1 |
| an operand is not a valid integer: message naming it | 2 |
| an operator is not one of `+ - x / %`: message naming it | 3 |
| a `/` or `%` followed by an operand equal to 0 | 4 |

Arguments are checked from left to right; the first bad one decides the error. Messages go to
**stderr** (wording is free).
