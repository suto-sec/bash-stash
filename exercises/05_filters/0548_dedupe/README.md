# 0548 · dedupe.sh (remove repeated lines, keep the order)

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★★★☆ · **Commands:** cat -n, sort -u -s -k, sort -n, cut, uniq -cd, cp

Write `dedupe.sh`:

```
dedupe.sh FILE
```

It removes the repeated lines of `FILE` **in place**, keeping only the **first** occurrence of each
line and the original order of the lines that remain (so plain `sort -u` is not enough).
The file has no empty lines.

- If there are repeated lines:
  1. save a copy of the original file as `FILE.bak` (overwrite it if it exists)
  2. print every line that appeared more than once as `<count>x <line>`, sorted by count
     descending and, for equal counts, by the line (in `sort` order)
  3. rewrite `FILE` without the repetitions (it must keep its permissions)
  4. print `Removed D duplicate lines (L -> U lines)` (original lines, lines that remain)
- If there are none: print `No duplicates in FILE` (with the name as given) and change nothing
  (no `.bak` is created).

Errors (message on **stderr**, nothing changed):

- not exactly 1 argument: error and usage, exit **1**
- `FILE` is not a regular file: message with its name, exit **2**
- `FILE` is not writable: message with its name, exit **3**

Hint: `cat -n` numbers the lines; `sort -s -u` keeps the first of each group of equal keys.
