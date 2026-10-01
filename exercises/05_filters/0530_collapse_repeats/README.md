# 0530 · "Last message repeated N times"

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★★☆☆ · **Commands:** uniq -c -f, sed -E

`syslog.txt` has lines `HH:MM:SS message`. Like a real syslog, collapse the runs of **consecutive**
lines whose **message** is identical (the timestamp, i.e. the first field, is ignored):

- print the **first** line of each run (with its timestamp)
- if the run has more than one line, append ` (xN)` where N is the length of the run

```
10:00:01 link up
10:00:02 link down           10:00:01 link up
10:00:03 link down     →     10:00:02 link down (x3)
10:00:04 link down           10:00:05 link up
10:00:05 link up
```

Equal messages that are **not** consecutive are not merged. Comparisons are case-sensitive.
Hint: `uniq -c -f 1`.
