# 0515 · sed: deleting and printing lines

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★☆☆☆ · **Commands:** sed /re/d, sed -n p

For the file `config.conf`, print separated by `---`:

1. the file **without** comment lines (lines starting with `#`) and without empty lines
2. only lines 2 to 4 (`sed -n`)
3. only the lines containing `port` (`sed -n '/.../p'`)
