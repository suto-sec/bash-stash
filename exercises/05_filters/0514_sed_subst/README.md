# 0514 · sed substitutions

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★☆☆☆ · **Commands:** sed s///, s///g

For the file `passwd`, print (separated by `---`):

1. its content replacing **every** `a` with `AAA`
2. its content replacing only the **first** `sys` of each line with `SYSTEM`
3. its content replacing `/bin/bash` with `/bin/zsh` (tip: use another delimiter, `s#...#...#`)

Use `sed`.
