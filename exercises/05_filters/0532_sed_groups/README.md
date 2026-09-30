# 0532 · Reordering with sed groups

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★★☆☆ · **Commands:** sed -E, \( \) and \1

Print, separated by a line `---`:

1. the file `notas.txt` with **every** date written as `DD/MM/YYYY` (exactly 2, 2 and 4 digits)
   changed into `YYYY-MM-DD`; the rest of the text is unchanged (things like `3/4` are not dates)
2. the file `contactos.txt`, whose lines are `Surname, Name: phone`, with every line rewritten as
   `Name Surname (phone)`

Use `sed` with groups and back-references (`-E` and `\1`, `\2`...).

---
Write your solution in `answer.sh`, then run `check 0532`.  
To experiment with the same test files the checker uses: `play 0532`.
