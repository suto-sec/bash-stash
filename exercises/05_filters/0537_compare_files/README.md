# 0537 · How do two files differ?

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★★☆☆ · **Commands:** cmp, cmp -s, diff -w -q

Write a script `A B` that compares two files and prints **one** line (then exits with the code
shown), checking the cases in this order:

| case | output | exit |
|------|--------|------|
| same bytes | `identical` | 0 |
| different, but `diff -w` finds no difference (only whitespace changes) | `same except whitespace` | 1 |
| one file is the beginning of the other (`cmp` reports `EOF on ...`) | `<shorter> is a prefix of <longer>` | 2 |
| otherwise | `differ at byte X, line L` (the first difference, as `cmp` reports it) | 3 |

`<shorter>` and `<longer>` are the file names as given in the arguments. Names may contain spaces.
Nothing may be printed on stderr.

---
Write your solution in `answer.sh`, then run `check 0537`.  
To experiment with the same test files the checker uses: `play 0537`.
