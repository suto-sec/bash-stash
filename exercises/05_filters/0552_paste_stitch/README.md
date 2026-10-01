# 0552 · paste's "- - -" trick: grouping every N lines

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★★☆☆ · **Commands:** paste -d, - - -

`datos.txt` has a number of lines that is always a **multiple of 3**. Using a **single** `paste`
call — not a loop, not `sed`, not `sort` — group every three consecutive lines into one output
line, the three values joined by a comma, in file order (`paste -d, - - -` reads three lines from
its input for every output line, one per `-`).
