# 0614 · Validating formats

**Topic:** grep & regular expressions · **Difficulty:** ★★★★☆ · **Commands:** grep -E, anchors, groups

`fechas.txt` has one candidate per line. Print only the lines that are a date `YYYY-MM-DD` where:

- the year is 4 digits starting with `19` or `20`
- the month is `01` to `12`
- the day is `01` to `31`

The whole line must be the date (nothing before or after).
