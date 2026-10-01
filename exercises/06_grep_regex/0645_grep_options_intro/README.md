# 0645 · grep -i -n -v -c

**Topic:** grep & regular expressions · **Difficulty:** ★☆☆☆☆ · **Commands:** grep -i -n -v -c

Four useful `grep` options: `-i` ignores upper/lower case, `-n` puts the line number in front of every line, `-v` inverts the search (lines that do **not** match) and `-c` prints only how many lines there are.

For the file `log.txt`, print, with a line `---` in between:

1. the lines that contain `error` in any case (`error`, `ERROR`, `Error`...), each one with its line number
2. only the **number** of lines that do **not** contain `error` (in any case)

Example: if `log.txt` contains

```
INFO inicio
warn disco
Error red
debug x
ERROR fin
```

the output is

```
3:Error red
5:ERROR fin
---
3
```

Hint: combine options, for example `grep -in word file` and `grep -vic word file`.
