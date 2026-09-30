# 0636 · ini.sh (reading a section of an INI file)

**Topic:** grep & regular expressions · **Difficulty:** ★★★★☆ · **Commands:** grep -n -x -F, tail -n +N, sed, grep -v -E

Write `ini.sh`:

```
ini.sh FILE SECTION
```

`FILE` is an INI file. The section starts at the line that is **exactly** `[SECTION]` (whole line;
the name is taken literally, even if it contains `.` or spaces) and ends before the next line that
starts with `[`, or at the end of the file. If the header appears several times, use the first one.

Inside the section, ignore empty lines, lines with only blanks, comment lines (first non-blank
character `#` or `;`) and lines without `=`. Every other line is `key = value`: print it as
`key=value` in the order of the file, where `key` is the text before the first `=` and `value` the
text after it, both without leading/trailing blanks (the value may contain more `=`).
Finally print `<N> keys in [SECTION]`.

Errors (message on **stderr**):

| situation | exit |
|-----------|------|
| not exactly 2 arguments (show the usage) | 1 |
| `FILE` not a readable regular file | 2 |
| section not found (mention it) | 3 |

---
Write your solution in `answer.sh`, then run `check 0636`.  
To experiment with the same test files the checker uses: `play 0636`.
