# 0624 · Stripping comments and blank lines

**Topic:** grep & regular expressions · **Difficulty:** ★★★☆☆ · **Commands:** grep -v -E, [[:space:]], cut, sort

`app.conf` is a configuration file. A **comment** line is one whose first non-blank character is `#`;
a **blank** line is empty or contains only spaces/tabs. Settings are lines `name=value` starting at
column 1 (a `#` inside a value, like `color=#ff0000`, is not a comment). Print:

1. the file without comment lines and without blank lines (the other lines unchanged, in order)
2. `---`
3. the names of the settings whose value is **empty** (nothing, or only blanks, after the `=`), sorted

---
Write your solution in `answer.sh`, then run `check 0624`.  
To experiment with the same test files the checker uses: `play 0624`.
