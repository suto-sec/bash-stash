# 1520 · Parsing KEY=VALUE lines with IFS

**Topic:** Loops: for, while, until, read · **Difficulty:** ★★★☆☆ · **Commands:** while IFS= read -r, IFS='=' read, [[ == ]]

`app.conf` is a configuration file. Read it line by line and, in file order:

- ignore blank lines and lines starting with `#` (they print nothing)
- a line containing `=` whose part **before the first** `=` (the key) is not empty is a setting:
  print `KEY=[VALUE]`, where VALUE is everything after the first `=` (it may be empty, contain
  spaces or even more `=` characters)
- any other line (no `=` at all, or an empty key) prints `line N: ignored` (N = line number in the
  file, counting every line)

Finally print `K settings, B ignored`.

Hint: `IFS='=' read -r key value <<< "$line"` puts the first field in `key` and **the rest of the
line** in the last variable.

---
Write your solution in `answer.sh`, then run `check 1520`.  
To experiment with the same test files the checker uses: `play 1520`.
