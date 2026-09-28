# 0506 · cut with a delimiter

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★☆☆☆☆ · **Commands:** cut -d -f

From the `/etc/passwd`-like file `passwd` (fields separated by `:`), print for every user:
the **UID** (field 3), the **home directory** (6) and the **shell** (7), separated by `:`.

---
Write your solution in `answer.sh`, then run `check 0506`.  
To experiment with the same test files the checker uses: `play 0506`.
