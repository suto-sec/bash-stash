# 0554 · uniq -f: ignoring a leading field

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★★☆☆ · **Commands:** uniq -f, uniq -c

`estado.log` has lines `HH:MM:SS mensaje` (the message may contain spaces and is never empty).
Using a **single** `uniq` call, collapse every run of **consecutive** lines that share the same
message — ignoring the timestamp when comparing (`uniq -f1` skips the first field) — and prefix
each surviving line with how many lines it represents, exactly the format `uniq -c` produces (the
line kept is the **first** one of the run, timestamp included).

The same message reappearing **later, without being part of that consecutive run**, must **not**
be merged with the earlier one — that is exactly what makes `uniq -f1 -c` different from grouping
by message globally.

---
Write your solution in `answer.sh`, then run `check 0554`.  
To experiment with the same test files the checker uses: `play 0554`.
