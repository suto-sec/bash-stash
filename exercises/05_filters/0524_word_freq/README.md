# 0524 · Word frequency

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★★★☆ · **Commands:** tr, sort, uniq -c, head

Print the **5 most frequent words** of `articulo.txt` with their count, in `uniq -c` format,
most frequent first. For equal counts, alphabetical order of the word.

- words are sequences of letters; convert everything to lowercase first
- anything that is not a letter separates words

Hint: `tr -cs 'A-Za-z' '\n'` puts every word on its own line.
