# 0529 · Caesar cipher with tr

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★★☆☆ · **Commands:** tr, cut -c, ${var^^}

Write a script that receives a number `N` (0 to 25) and encrypts **standard input** with a Caesar
cipher: every letter is replaced by the letter `N` positions later in the alphabet, wrapping around
(`N=3`: `a→d`, `x→a`, `Z→C`). Uppercase stays uppercase, lowercase stays lowercase, everything else
(digits, spaces, punctuation) is unchanged. Only the 26 ASCII letters appear.

Hint: `abc...zabc...z` (the alphabet twice) contains every rotated alphabet: `cut -c` it out and
give it to `tr`.

---
Write your solution in `answer.sh`, then run `check 0529`.  
To experiment with the same test files the checker uses: `play 0529`.
