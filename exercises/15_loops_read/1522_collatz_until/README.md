# 1522 · until: the Collatz sequence

**Topic:** Loops: for, while, until, read · **Difficulty:** ★★★☆☆ · **Commands:** until, $(( )), %

The script receives a positive integer N. Starting from N, repeatedly apply: if the number is even,
halve it; if it is odd, replace it by `3*n + 1`, **until** it becomes 1. Print:

```
N a b c ... 1
steps: S, max: M
```

The first line is the whole sequence (N included, separated by single spaces), S is the number of
steps applied and M the biggest value reached. For N = 1 the sequence is just `1` (0 steps).
Use an `until` loop.

---
Write your solution in `answer.sh`, then run `check 1522`.  
To experiment with the same test files the checker uses: `play 1522`.
