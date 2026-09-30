# 1537 · histograma.sh: counting per hour

**Topic:** Loops: for, while, until, read · **Difficulty:** ★★★★☆ · **Commands:** while read -r, arrays, 10#, for (( )), printf

Write `histograma.sh LOG [LEVEL]`. Every line of LOG should look like
`YYYY-MM-DD HH:MM:SS LEVEL message...`. A line is **malformed** unless its 1st field matches
`^[0-9]{4}-[0-9]{2}-[0-9]{2}$`, its 2nd field is a valid time `HH:MM:SS` (HH 00–23, MM and SS 00–59)
and its 3rd field is `INFO`, `WARN` or `ERROR`. Count the well-formed entries per hour (only those of
LEVEL, if given; LEVEL is case-insensitive). For every hour with at least one entry, from 00 to 23,
print

```
printf '%s %3d %s\n' HH COUNT BAR
```

where BAR is one `#` per entry. Then, if there was some entry, `busiest: HH (N)` (the earliest hour
if tied), and always `total: T entries, H hours, M malformed` (M counts every malformed line,
whatever LEVEL is).

Careful: `$((08 + 1))` is an error in bash (leading 0 = octal): use `$((10#08))`.

Errors (stderr): no arguments or more than 2 → **1** (usage); LOG not a readable regular file →
**2** (name it); LEVEL not one of info/warn/error in any case → **3** (name it).

---
Write your solution in `answer.sh`, then run `check 1537`.  
To experiment with the same test files the checker uses: `play 1537`.
