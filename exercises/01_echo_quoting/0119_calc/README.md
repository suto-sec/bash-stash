# 0119 · calc.sh: a calculator that survives *

**Topic:** Echo, quoting & substitution · **Difficulty:** ★★★★☆ · **Commands:** $(( )), [[ =~ ]], case, quoting, exit codes

Write `calc.sh`:

```
calc.sh A OP B
```

`A` and `B` are integers (an optional `-` followed by one or more digits; no leading zeros are used)
and `OP` is one of `+`, `-`, `x`, `*` (both `x` and `*` multiply), `/` (integer division, as
`$(( ))` does it) or `%` (remainder). It prints two lines:

```
A OP B = R
R is even
```

where the first line shows the arguments exactly as received (`7 * 6 = 42`) and the second says
`even` or `odd` (0 is even; negative numbers too: `-3 is odd`).

Errors (message on **stderr**, nothing on stdout), checked in this order:

- not exactly 3 arguments: usage message, exit **1**
- `A` or `B` is not an integer: exit **2**, the message must include the offending value
- `OP` is not one of the six operators: exit **3**, the message must include it
- `/` or `%` with `B` equal to 0: exit **4**

Careful: the user will call it as `calc.sh 7 '*' 6`. Your script runs in a directory that contains
files, so an unquoted `*` would be expanded.
