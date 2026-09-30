# 0536 · Newest first, three per row

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★★☆☆ · **Commands:** tac, paste - - -, paste -s -d

`eventos.txt` has one event per line, oldest first (events contain spaces but no `,` or `;`).
Print:

1. the events **newest first**, **three per line**, separated by `,`. If the number of events is
   not a multiple of 3, the last row is completed with empty fields (e.g. `ev1,,`), exactly as
   `paste` does it.
2. a line `---`
3. all the events **oldest first** in a single line, separated by `;`

Hint: `paste - - -` reads three lines of its input for every output line.

---
Write your solution in `answer.sh`, then run `check 0536`.  
To experiment with the same test files the checker uses: `play 0536`.
