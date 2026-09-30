# 0557 · bytesdiff.sh: wrapping cmp -l with validation

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★★★☆ · **Commands:** cmp -l, wc -c, script argument, distinct exit codes

Write `bytesdiff.sh`:

```
bytesdiff.sh FILE1 FILE2
```

If both files are byte-identical, print exactly `Identical` and exit **0**. Otherwise, if they have
the **same size**, print every differing byte exactly as `cmp -l` prints it, then a line
`Total: N bytes differ`, and exit **4**.

Errors (message on **stderr**, nothing on stdout), checked in this order:

- not exactly 2 arguments: error and usage, exit **1**
- one of the files is not a readable regular file: message with its name, exit **2**
- the files have **different sizes** (so a byte-by-byte comparison is not meaningful): message
  naming both files, exit **3**

---
Write your solution in `answer.sh`, then run `check 0557`.  
To experiment with the same test files the checker uses: `play 0557`.
