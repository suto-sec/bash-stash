# 1419 · Numbers compared as numbers and as strings

**Topic:** test, if & case · **Difficulty:** ★★★☆☆ · **Commands:** test -lt -gt, [[ < > ]]

Write `cmp2.sh a b` where `a` and `b` are non-negative integers (digits only). Print two lines:

```
numeric: a OP b
string: a OP b
```

where `OP` is `<`, `=` or `>`: in the first line comparing them as **numbers** (`-lt`, `-gt`), in the
second one comparing them as **strings** (`[[ $a < $b ]]`, `[[ $a > $b ]]`, `==`). For example
`cmp2.sh 10 9` prints `numeric: 10 > 9` and `string: 10 < 9`.

(Beware: inside `[ ]` a bare `<` is a redirection!)

If there are not exactly 2 arguments or one is not made of digits only, print
`Usage: cmp2.sh a b` on stderr (use `$(basename "$0")`) and exit **1**.
