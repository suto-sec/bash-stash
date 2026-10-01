# 0564 · uniq: removing adjacent duplicates

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★☆☆☆☆ · **Commands:** uniq

`uniq` collapses lines that are repeated **one right after another** into a single line.

`lista.txt` is already sorted, so equal lines are next to each other. Print it with every repetition collapsed.

Example: if `lista.txt` contains `cafe`, `cafe`, `pan`, `pan`, `sal`, the output is `cafe`, `pan`, `sal`.

Hint: `uniq file`

---
Write your solution in `answer.sh`, then run `check 0564`.  
To experiment with the same test files the checker uses: `play 0564`.
