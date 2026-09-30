# 1528 · Arrays and C-style loops: moving average

**Topic:** Loops: for, while, until, read · **Difficulty:** ★★★☆☆ · **Commands:** mapfile / while read, for (( )), arrays

`temps.txt` has one integer temperature per line (they may be negative; there are at least 4).
Load them into an array and print:

1. for every line i from 3 to the end: `i: a b c -> AVG`, where a, b, c are the values of lines
   i-2, i-1 and i, and AVG is `$(( (a + b + c) / 3 ))` (bash integer division)
2. `max rise: D (line i -> j)`: the biggest difference `next - current` between two consecutive
   lines (it can be negative), the first pair if tied; j = i + 1

---
Write your solution in `answer.sh`, then run `check 1528`.  
To experiment with the same test files the checker uses: `play 1528`.
