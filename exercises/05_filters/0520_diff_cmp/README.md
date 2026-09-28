# 0520 · Comparing files

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★☆☆☆ · **Commands:** diff, cmp, diff -q

Print:

1. the output of `diff v1.txt v2.txt`
2. `---`
3. the output of `cmp v1.txt v2.txt`
4. `---`
5. the output of `diff -q` on `v1.txt` and `copia.txt` (identical files: prints nothing),
   followed by `equal` if they are equal

The script must finish with exit code 0.

---
Write your solution in `answer.sh`, then run `check 0520`.  
To experiment with the same test files the checker uses: `play 0520`.
