# 1615 · A recursive palindrome check

**Topic:** Functions · **Difficulty:** ★★★☆☆ · **Commands:** recursion, return, substring expansion

Write a **recursive** function `es_palindromo STR` that **returns** 0 if STR reads the same
forwards and backwards (case-sensitive; spaces count) and 1 otherwise. Compare the first and last
characters (`${s:0:1}` and `${s: -1}`) and, if they match, recurse on the substring with both ends
removed (`${s:1:${#s}-2}`); the base case is a string of length 0 or 1.

For each script argument print `V: palindromo` or `V: no palindromo`.

---
Write your solution in `answer.sh`, then run `check 1615`.  
To experiment with the same test files the checker uses: `play 1615`.
