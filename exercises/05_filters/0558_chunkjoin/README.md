# 0558 · chunkjoin.sh: dynamic paste grouping

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★★★☆ · **Commands:** paste -d, (dynamic placeholders), seq, wc -l, script argument

Write `chunkjoin.sh`:

```
chunkjoin.sh FILE K
```

Groups every `K` consecutive lines of `FILE` into one comma-joined output line, in file order,
using the `paste -d, - - ...` trick from exercise 0552 — except here `K` is only known at run
time, so the `K` placeholders (`-`) must be **built dynamically** (hint: `seq "$K"` to generate `K`
of them into an array, then pass that array to `paste`).

Errors (message on **stderr**, nothing on stdout):

- not exactly 2 arguments: error and usage, exit **1**
- `FILE` is not a readable regular file: message with its name, exit **2**
- `K` is not a positive integer: message with it, exit **3**
- the number of lines of `FILE` is not a multiple of `K`: message naming `FILE` and its line count,
  exit **4**
