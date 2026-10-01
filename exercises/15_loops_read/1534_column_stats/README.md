# 1534 · stats_col.sh: statistics of one column

**Topic:** Loops: for, while, until, read · **Difficulty:** ★★★★☆ · **Commands:** read -ra, arrays, for (( )), [[ =~ ]], printf

Write `stats_col.sh FILE COL`. FILE has a header line with the column names and then data lines;
fields are separated by blanks. COL selects a column either by **number** (only digits, 1-based) or
by **name** (the first header field equal to it). Values in the selected column that are
non-negative integers (digits only) are used; any other value, or a missing field, is skipped.
Print:

```
column: NAME
count: N
min: X
max: Y
sum: S
avg: A
skipped: K
```

NAME is the header of the column, A the average with exactly 2 decimals **truncated** (e.g. `12.66`).
If no value was usable, print only the `column`, `count: 0` and `skipped` lines and exit with **4**.

Errors (stderr, wording free): not exactly 2 arguments → **1** (usage); FILE not a readable regular
file → **2** (name it); COL is a number out of range or a name that is not in the header → **3**
(name it).
