# 1525 · Counters: a wc written with loops

**Topic:** Loops: for, while, until, read · **Difficulty:** ★★★☆☆ · **Commands:** while IFS= read -r, ${#var}, counters

Without using `wc`, compute for `texto.txt` (ASCII text that ends with a newline):

```
lines: L
words: W
chars: C
longest: N chars (line K)
```

- words are separated by spaces/tabs; C counts every character **including the newlines**
  (the same as `wc -c`)
- `longest` is the line with the most characters (newline not counted), the first one if tied
- leading spaces are part of a line
