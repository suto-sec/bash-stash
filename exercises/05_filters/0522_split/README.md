# 0522 · Splitting a file

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★★☆☆ · **Commands:** split -l, split -d

Split `grande.txt` into pieces of **10 lines** each named `parte_00`, `parte_01`, ... (numeric
suffixes, see `-d`), in the current directory. Then print how many pieces were created.
