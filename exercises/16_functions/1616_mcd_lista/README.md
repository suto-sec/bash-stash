# 1616 · Folding gcd across a list with recursion

**Topic:** Functions · **Difficulty:** ★★★☆☆ · **Commands:** recursion, $(func), local

Write a **recursive** function `mcd A B` (Euclid's algorithm: `mcd A B` is `mcd B (A % B)` when B
is not 0, otherwise A) for two non-negative integers, returning the result with `echo`/`$( )`
(the value may be too big to fit in a `return` status).

The script receives two or more non-negative integers. Compute the gcd of *all* of them by folding
`mcd` from left to right, and print `mcd = R`.

---
Write your solution in `answer.sh`, then run `check 1616`.  
To experiment with the same test files the checker uses: `play 1616`.
