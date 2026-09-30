# 0533 · Extracting an INI section

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★★☆☆ · **Commands:** sed -n '/a/,/b/p', sed d, grep -q

Write a script `FILE SECTION` that prints the settings of one section of an INI file:

```
[server]
# a comment
port=8080
; another comment

host=example.com
[db]
...
```

A section starts at the line `[SECTION]` (exactly that, at the start of the line) and ends right
before the next line starting with `[`, or at the end of the file. Print the lines of that section,
unchanged and in order, **except**: the `[SECTION]` header, comment lines (starting with `#` or `;`)
and blank lines (empty or only spaces).

- If the section exists (even if it has no settings): exit code 0.
- If there is no `[SECTION]` line: print nothing, exit code 1.

Section names contain only letters, digits and `_`. The file name may contain spaces.

---
Write your solution in `answer.sh`, then run `check 0533`.  
To experiment with the same test files the checker uses: `play 0533`.
