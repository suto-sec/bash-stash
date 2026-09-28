# 0509 · Numeric sort

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★☆☆☆ · **Commands:** sort -n, sort -h

`numeros.txt` contains one integer per line; `tamanos.txt` contains human readable sizes like
`4K`, `1.5M`, `2G`. Print, separated by `---`:

1. `numeros.txt` sorted numerically ascending (note: plain `sort` puts `10` before `9`)
2. `numeros.txt` sorted numerically **descending**
3. `tamanos.txt` sorted ascending by real size

---
Write your solution in `answer.sh`, then run `check 0509`.  
To experiment with the same test files the checker uses: `play 0509`.
