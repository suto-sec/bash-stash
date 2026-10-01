# 0505 · A range of lines

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★☆☆☆ · **Commands:** head | tail, sed -n

The file `libro.txt` has many lines and the file `rango.txt` contains two numbers `A B` (A ≤ B).
Print lines A to B (both included) of `libro.txt`.

Do it first with `head` + `tail` in a pipeline; then try `sed -n 'A,Bp'`.
