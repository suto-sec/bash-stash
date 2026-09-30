# 0534 · One stream, several files

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★★☆☆ · **Commands:** tee, tee -a, grep

The script reads log lines (`LEVEL message`) from **standard input**. In **one pipeline**:

- save everything into `today.log` (overwriting it),
- **append** everything to `history.log` (it may already exist, with older lines),
- and print on the screen only the lines that start with `ERROR ` (the word ERROR as the level).

Then print `saved N lines`, where N is the number of lines of `today.log`.
The script must end with exit code 0.

Hint: `tee` can write several files, but `-a` would apply to all of them; you can chain two `tee`.

---
Write your solution in `answer.sh`, then run `check 0534`.  
To experiment with the same test files the checker uses: `play 0534`.
