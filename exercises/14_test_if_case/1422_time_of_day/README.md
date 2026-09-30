# 1422 · Morning, afternoon, evening or night

**Topic:** test, if & case · **Difficulty:** ★★★☆☆ · **Commands:** [[ =~ ]], test -le -lt, $((10#...)), if elif

Write `when.sh time...`. Each argument must be a time `HH:MM` (exactly two digits, a colon and two
digits, with `HH` ≤ 23 and `MM` ≤ 59). For each valid one print

```
HH:MM <period> (<N> min)
```

where N is the number of minutes since midnight and the period is `night` (00:00-05:59), `morning`
(06:00-11:59), `afternoon` (12:00-19:59) or `evening` (20:00-23:59). For each invalid one print
`invalid time: <arg>` on **stderr** and go on.

Exit code: **0** if all were valid, **1** if some was invalid. With no arguments print
`Usage: when.sh HH:MM...` on stderr (use `$(basename "$0")`) and exit **2**.

Careful: `08` and `09` are invalid numbers in `$(( ))` (octal); use `$((10#$h))`.

---
Write your solution in `answer.sh`, then run `check 1422`.  
To experiment with the same test files the checker uses: `play 1422`.
