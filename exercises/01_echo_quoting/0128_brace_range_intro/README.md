# 0128 · Brace expansion {a..b}

**Topic:** Echo, quoting & substitution · **Difficulty:** ★☆☆☆☆ · **Commands:** {1..N}

Brace expansion writes a list of words for you: `{1..5}` becomes `1 2 3 4 5`.

Print the numbers 1 to 5 on one line, separated by spaces, with **one** `echo` and a brace expansion (no loop, no `seq`):

```
1 2 3 4 5
```

Hint: `echo {1..3}` prints `1 2 3`.
