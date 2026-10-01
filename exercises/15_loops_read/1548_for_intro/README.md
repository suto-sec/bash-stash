# 1548 · Quick refresher: for

**Topic:** Loops: for, while, until, read · **Difficulty:** ★☆☆☆☆ · **Commands:** for in, seq

A `for` loop repeats some commands once for every value of a list or a counter.

The script receives a number N. Print the numbers from 1 to N, one per line, using a `for` loop.

Example: run as `./script.sh 3` it prints:

```
1
2
3
```

Hint: `for ((i = 1; i <= $1; i++)); do echo "$i"; done` (or `for i in $(seq 1 $1)`).
