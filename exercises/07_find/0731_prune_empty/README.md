# 0731 · vaciar.sh: removing empty files and directories

**Topic:** find · **Difficulty:** ★★★★☆ · **Commands:** find -empty, -delete, -depth, sort -r

Write `vaciar.sh`:

```
vaciar.sh DIR
```

It cleans `DIR` (recursively) in two steps:

1. deletes every **empty regular file** (size 0, hidden ones included) and prints
   `removed file <path>` for each, in `sort` order;
2. then deletes every **empty directory**, including the ones that **become** empty when their empty
   contents are removed (e.g. `a/b/c` with nothing else: `c`, then `b`, then `a`). `DIR` itself is
   **never** removed. Print `removed dir <path>` for each, sorted with `sort -r` (so children come
   before their parents).

Paths as `find` prints them (starting with `DIR` as given). Finally print
`Removed N empty files and M empty directories`.

A directory that contains a symbolic link is not empty, and symbolic links are never deleted.

Hint: `-delete` implies `-depth` (children are processed before their directory), so
`find ... -type d -empty -delete` also removes the directories that become empty; add `-print`
to know which ones.

Errors (stderr, wording free): not exactly one argument → exit **1**; `DIR` is not a directory →
exit **2**. Names may contain spaces.

---
Write your solution in `answer.sh`, then run `check 0731`.  
To experiment with the same test files the checker uses: `play 0731`.
