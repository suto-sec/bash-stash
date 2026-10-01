# 0513 · tr -d and tr -s

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★☆☆☆ · **Commands:** tr -d, tr -s, tr -c

Read text from **standard input** and, in a single pipeline:

1. delete every digit
2. squeeze runs of repeated spaces into a single space

Then, as a second output line group, print the file `ruido.txt` keeping **only** letters and newlines
(delete everything else: `tr -cd`).
