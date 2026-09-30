# 0527 · Fixed-width columns

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★★☆☆ · **Commands:** cut -c, sed, tr -d, paste, sort -t -k

`inventario.txt` is a **fixed-width** report (no delimiter between columns):

| characters | content | padding |
|------------|---------|---------|
| 1-6   | product code | spaces on the right |
| 7-26  | product name (may contain spaces) | spaces on the right |
| 27-31 | quantity | spaces on the **left** |

Print every product as `code;name;quantity`, with the padding spaces removed (the spaces **inside**
a name are kept), sorted by **quantity descending** (numeric) and, for equal quantities, by
**code** (as `sort` orders them).

Example: `P1231 red apple            7` becomes `P1231;red apple;7`.

---
Write your solution in `answer.sh`, then run `check 0527`.  
To experiment with the same test files the checker uses: `play 0527`.
