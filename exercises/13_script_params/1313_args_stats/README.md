# 1313 · Statistics of the arguments

**Topic:** Script parameters & exit codes · **Difficulty:** ★★★☆☆ · **Commands:** for, $(( )), test -lt -gt

The script receives integer numbers as arguments. Print:

```
count: N
sum: S
min: m
max: M
```

With no arguments, print `No numbers` on stderr and exit 1. If some argument is **not** an integer
(optional `-` and digits), print `Not a number: X` on stderr and exit 2.
