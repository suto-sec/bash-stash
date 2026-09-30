# 0643 · colgrep.sh: matching a regex against one column

**Topic:** grep & regular expressions · **Difficulty:** ★★★★☆ · **Commands:** cut -d, grep -nE, grep -E (validity test), sed -n Np, script argument

Write `colgrep.sh`:

```
colgrep.sh FILE COLNUM PATTERN
```

`FILE` has `:`-separated records, no header. Print every **whole line** of `FILE` whose field
number `COLNUM` (1-based) matches the extended regular expression `PATTERN` (matching anywhere in
the field, not necessarily the whole field), in file order. Then print:

```
Total: N lines
```

Errors (message on **stderr**, nothing on stdout):

- not exactly 3 arguments: error and usage, exit **1**
- `FILE` is not a readable regular file: message with its name, exit **2**
- `COLNUM` is not a positive integer: message with it, exit **3**
- `PATTERN` is not a syntactically valid ERE (test it against empty input first; `grep -E` exits
  with status **2** for a bad pattern): message with it, exit **4**

---
Write your solution in `answer.sh`, then run `check 0643`.  
To experiment with the same test files the checker uses: `play 0643`.
