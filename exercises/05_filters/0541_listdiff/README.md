# 0541 · listdiff.sh (what changed between two lists)

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★★★☆ · **Commands:** sort -u, diff, sed, grep -c, mktemp

Write `listdiff.sh`:

```
listdiff.sh OLD NEW
```

`OLD` and `NEW` are lists with one item per line, unsorted, possibly with repeated items and
empty lines (empty lines are ignored; items may contain spaces). The script prints:

1. every item that is in `OLD` but not in `NEW`, as `- item`, sorted (as `sort` orders them), once
2. every item that is in `NEW` but not in `OLD`, as `+ item`, sorted, once
3. the summary line `Removed: R, added: A, kept: K` (K = different items present in both)

Exit code, like `diff`: **0** if both lists have the same items, **1** if they differ.

Errors (message on **stderr**):

- not exactly 2 arguments: error and usage, exit **2**
- one of the files is not a readable regular file: message with its name, exit **3**

Hint: once both lists are sorted without repetitions, `diff` marks the removed items with `<` and
the added ones with `>`.
