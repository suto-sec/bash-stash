# 1627 · A function called per loop item, its echo used by the caller

**Topic:** Functions · **Difficulty:** ★★★☆☆ · **Commands:** while read, $(func), local

`medidas.txt` has one integer per line (it may be negative). Write a function `clasifica VALOR` that
**echoes** exactly one word: `negativo` (VALOR < 0), `cero` (VALOR == 0), `bajo` (1-9), `medio`
(10-99) or `alto` (>= 100).

Read `medidas.txt` line by line. For each line, call `clasifica` and capture its echoed word with
`$(...)`; use that value to print `VALOR: CATEGORIA` and to accumulate a per-category counter.

After the loop, print every category that occurred **at least once**, sorted alphabetically, as
`CATEGORIA: N`. Finally print `total: T` (T = number of lines processed).

---
Write your solution in `answer.sh`, then run `check 1627`.  
To experiment with the same test files the checker uses: `play 1627`.
