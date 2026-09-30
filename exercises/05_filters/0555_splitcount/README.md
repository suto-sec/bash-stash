# 0555 · splitcount.sh: line/word counts of split chunks

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★★★☆ · **Commands:** split -l, mktemp -d, wc -l, wc -w, script argument

Write `splitcount.sh`:

```
splitcount.sh FILE N
```

Splits `FILE` into chunks of at most `N` lines each (`split -l N`, in a scratch directory so the
original directory is left untouched) and, for each chunk **in order**, prints:

```
chunk K: L lines, W words
```

(`K` starting at 1, `L` and `W` from `wc`). Finally prints:

```
Total: C chunks
```

Errors (message on **stderr**, nothing on stdout):

- not exactly 2 arguments: error and usage, exit **1**
- `FILE` is not a readable regular file: message with its name, exit **2**
- `N` is not a positive integer: message with it, exit **3**

---
Write your solution in `answer.sh`, then run `check 0555`.  
To experiment with the same test files the checker uses: `play 0555`.
