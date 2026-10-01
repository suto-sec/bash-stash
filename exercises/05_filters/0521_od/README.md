# 0521 · Looking at bytes with od

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★★☆☆ · **Commands:** od -c, od -An -tx1

`raro.txt` contains invisible characters (tabs, carriage returns...). Print:

1. its content as characters with `od -c`
2. `---`
3. its first 8 bytes in hexadecimal, one byte per unit, **without** the offset column (`-An -tx1 -N8`)
