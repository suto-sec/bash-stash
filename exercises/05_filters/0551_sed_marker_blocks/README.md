# 0551 · Extracting several blocks with sed ranges

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★★☆☆ · **Commands:** sed -n, /pat/,/pat/, address deletion, s///

`bitacora.txt` contains several blocks delimited by a line that is **exactly** `BEGIN` and, later, a
line that is **exactly** `END` (several such blocks appear in the file, with other lines in between
that are not part of any block). Using a **single** `sed` command, print the inner lines of every
block followed by a line containing exactly `---` (so `---` is printed once per block, including the
last one).

Watch the decoys: a line that merely contains the word `BEGIN` or `END` as part of a longer line
(like `BEGINNING` or `ENDED`) is **not** a marker and must be ignored — matching the marker lines
requires anchoring the whole line (`^BEGIN$`, `^END$`), not just searching for the word.

---
Write your solution in `answer.sh`, then run `check 0551`.  
To experiment with the same test files the checker uses: `play 0551`.
