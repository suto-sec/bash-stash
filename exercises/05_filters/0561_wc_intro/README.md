# 0561 · wc: counting lines

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★☆☆☆☆ · **Commands:** wc -l

`wc -l` counts the lines of a file.

Print **only the number** of lines of `texto.txt`, without the file name.

Example: for a file with 7 lines, print just `7`.

Hint: `wc -l texto.txt` prints the number **and** the name (`7 texto.txt`). If the file arrives through input redirection, `wc -l < texto.txt`, `wc` does not know its name and prints only the number.

---
Write your solution in `answer.sh`, then run `check 0561`.  
To experiment with the same test files the checker uses: `play 0561`.
