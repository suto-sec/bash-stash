# 1425 · safe_copy.sh: copying without losing newer work

**Topic:** test, if & case · **Difficulty:** ★★★★☆ · **Commands:** test -e -f -r -d -ef -nt, cmp -s, dirname, basename, exit codes

Write `safe_copy.sh`, a careful `cp`:

```
safe_copy.sh [-f] src dst
```

If `dst` is a directory the target is `<dst>/<name of src>` (built literally, e.g. `out/a.txt`);
otherwise the target is `dst` itself. Then, checking in this order:

1. the target does not exist: copy, print `Copied <src> -> <target>`
2. the target has the same content as `src` (`cmp -s`): do nothing, print `Unchanged <target>`
3. the target is **newer** than `src` (`-nt`) and `-f` was not given: do nothing, print
   `Kept <target> (newer than <src>)`
4. otherwise overwrite it, print `Updated <target>`

All four end with exit code 0. `-f` is only recognised as the first argument.

Errors (message on **stderr**, wording free, nothing copied), checked in this order:

| error | exit |
|-------|------|
| not `[-f] src dst` (show the usage) | 1 |
| `src` does not exist (name it) | 2 |
| `src` is not a regular file (name it) | 3 |
| `src` is not readable (name it) | 4 |
| `dst` is not a directory and its parent directory does not exist (name `dst`) | 5 |
| the target is the same file as `src` (`-ef`) | 6 |

---
Write your solution in `answer.sh`, then run `check 1425`.  
To experiment with the same test files the checker uses: `play 1425`.
