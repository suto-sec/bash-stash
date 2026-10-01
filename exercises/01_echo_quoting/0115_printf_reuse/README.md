# 0115 · printf reuses its format

**Topic:** Echo, quoting & substitution · **Difficulty:** ★★★☆☆ · **Commands:** printf, $(cat ...), word splitting

The file `scores.txt` contains **one line** with pairs `name score` separated by single spaces
(e.g. `alpha 87 bravo 5 kilo 100`).

Print a table like this one:

```
NAME          SCORE
alpha            87
bravo             5
kilo            100
Players: 3
```

- header and rows use the format `%-10s %8s` / `%-10s %8d` (name left-aligned in 10 columns, a space,
  score right-aligned in 8 columns)
- the last line is `Players: N` with the number of pairs

Hint: when `printf` receives more arguments than its format uses, it **repeats the format**:
`printf '%s=%s\n' a 1 b 2` prints two lines. An **unquoted** `$(cat scores.txt)` is split into words.
No loops are needed.
