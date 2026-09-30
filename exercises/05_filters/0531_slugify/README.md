# 0531 · Slugs for titles

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★★☆☆ · **Commands:** tr, tr -cs, sed

Read titles from **standard input** (one per line, ASCII only) and print, for each one, its
**slug** (the kind of name used in URLs):

- uppercase letters become lowercase
- letters and digits are kept
- every run of **other** characters (spaces, punctuation, `_`, `.`...) becomes a **single** `-`
- no `-` at the beginning or at the end

Example: `  Hello, World!! 2026 -- v1.2 ` → `hello-world-2026-v1-2`.

---
Write your solution in `answer.sh`, then run `check 0531`.  
To experiment with the same test files the checker uses: `play 0531`.
