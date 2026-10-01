# 0733 · where.sh: searching several directories

**Topic:** find · **Difficulty:** ★★★★☆ · **Commands:** find -name "$PAT", shift, for "$@", exit codes

Write `where.sh`:

```
where.sh PATTERN DIR...
```

`PATTERN` is a glob for **names**, as used by `find -name` (e.g. `'*.txt'`, `'report*'`). For each
`DIR`, in argument order:

- if it is a directory: print a header `== DIR ==` (DIR as given) and then the **regular files** under
  it (recursively) whose name matches `PATTERN`, sorted, paths as `find` prints them; or the line
  `(no matches)` if there are none;
- if it is not a directory: print an error message on **stderr** that includes `DIR`, print nothing
  on stdout for it, and go on with the next one.

Finally print `N matches in M directories` (M = number of **valid** directories searched).

Exit code:

- fewer than 2 arguments: usage on stderr, exit **2** (nothing on stdout)
- some `DIR` was not a directory: **3**
- otherwise, **1** if there were no matches at all, **0** if there was at least one

Remember to quote the pattern everywhere, or the shell will expand it. Names may contain spaces.
