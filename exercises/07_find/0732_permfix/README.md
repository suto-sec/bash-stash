# 0732 · permfix.sh: normalising permissions

**Topic:** find · **Difficulty:** ★★★★☆ · **Commands:** find -type d -o -type f, stat -c %a, chmod

Write `permfix.sh`:

```
permfix.sh DIR
```

It normalises the permissions of everything under `DIR` (recursively, `DIR` included):

- directories → `755`
- regular files whose name ends in `.sh` → `755`
- other regular files → `644`
- anything else (symbolic links...) is ignored

For every entry whose permissions **actually change**, print (in sorted path order)

```
<old> -> <new> <path>
```

with the permissions in octal as `stat -c %a` prints them (e.g. `600 -> 644 d/notes.txt`) and the
path as `find` prints it. Finally print `Fixed N of M entries`, where M is the number of
directories and regular files examined.

Errors (stderr, wording free): not exactly one argument → exit **1**; `DIR` is not a directory →
exit **2**. Names may contain spaces.

---
Write your solution in `answer.sh`, then run `check 0732`.  
To experiment with the same test files the checker uses: `play 0732`.
