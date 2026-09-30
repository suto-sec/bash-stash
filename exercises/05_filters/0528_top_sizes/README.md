# 0528 · The biggest entries (human-readable sizes)

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★★☆☆ · **Commands:** sort -t -k -h -r, head

`uso.txt` looks like the output of `du -h`: every line is `SIZE<TAB>PATH`, where SIZE is a
human-readable size (`512`, `4.0K`, `20M`, `1.1G`...) and PATH may contain spaces.

The script receives an optional argument `N` (default **5**) and prints the `N` **biggest** lines,
unchanged, biggest first. Lines with the same size are ordered by PATH (as `sort` orders them).
If there are fewer than `N` lines, print them all.

Hint: `sort -h` understands the suffixes; use a TAB as the field separator.

---
Write your solution in `answer.sh`, then run `check 0528`.  
To experiment with the same test files the checker uses: `play 0528`.
