# 1536 · calendario.sh: nested loops and printf

**Topic:** Loops: for, while, until, read · **Difficulty:** ★★★★☆ · **Commands:** for (( )), printf %2d, [[ =~ ]], exit codes

Write `calendario.sh DAYS FIRST` that prints a month calendar. DAYS is the number of days (28–31)
and FIRST the weekday of day 1 (1 = Monday … 7 = Sunday). Output:

```
Mo Tu We Th Fr Sa Su
       1  2  3  4  5
 6  7  8  9 10 11 12
...
weeks: W, weekend days: E
```

Every cell is 2 characters wide (days with `printf %2d`, empty cells as 2 spaces) and cells are
separated by one space; lines have no trailing spaces. The last week ends at day DAYS. W = number of
week lines, E = number of days that fall on Saturday or Sunday.

Errors (stderr, checked in this order): not exactly 2 arguments → **1** (usage); an argument that is
not an integer (digits only; check DAYS first) → **2** (name it); DAYS not in 28–31 or FIRST not in
1–7 → **3** (name the bad value).
