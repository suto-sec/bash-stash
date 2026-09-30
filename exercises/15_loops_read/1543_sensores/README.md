# 1543 · Accumulating per-key stats while skipping outliers

**Topic:** Loops: for, while, until, read · **Difficulty:** ★★★☆☆ · **Commands:** while read, arrays, continue

`sensores.txt` has lines `SENSOR VALOR` (VALOR an integer, possibly negative or out of range).
A reading is **invalid** when VALOR is outside -50..150 (inclusive): print
`SENSOR: lectura invalida (VALOR)` and skip it (`continue`), it must not affect any statistic.

For every valid reading accumulate, per SENSOR, the count, the sum, the minimum and the maximum.
After the loop, for every sensor that had at least one valid reading, **sorted alphabetically by
name**, print:

```
SENSOR: N lecturas, min MIN, max MAX, media MEDIA
```

MEDIA is the integer average (`suma / N`). Finally print `total validas: V, invalidas: I`.

---
Write your solution in `answer.sh`, then run `check 1543`.  
To experiment with the same test files the checker uses: `play 1543`.
