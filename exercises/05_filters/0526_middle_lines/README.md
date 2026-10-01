# 0526 · The middle of a file

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★★☆☆ · **Commands:** wc -l, head, tail, $(( ))

Write a script that receives a file name as its only argument and prints the **middle** of it:

- if the file has an **odd** number of lines `N`, print line `(N+1)/2`
- if it has an **even** number of lines `N` (N > 0), print lines `N/2` and `N/2+1`
- if it is empty, print nothing

Use `wc -l`, `head` and `tail`. The file name may contain spaces. Exit code 0.
