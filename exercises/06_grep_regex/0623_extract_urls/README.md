# 0623 · Host names from URLs

**Topic:** grep & regular expressions · **Difficulty:** ★★★☆☆ · **Commands:** grep -oE, cut, sort -u, wc -l

`pagina.html` contains links. A URL starts with `http://` or `https://` (lowercase); its **host**
is the longest sequence of letters, digits, `.` and `-` right after `://`
(so it stops at `/`, `:`, `"`...). Print:

1. the **distinct** hosts of all the URLs, sorted, one per line
2. `---`
3. the number of URLs (occurrences, not lines!) that use plain `http://`

`ftp://`, `mailto:` and other schemes are not URLs here.

---
Write your solution in `answer.sh`, then run `check 0623`.  
To experiment with the same test files the checker uses: `play 0623`.
