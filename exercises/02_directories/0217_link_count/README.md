# 0217 · The link count of a directory

**Topic:** Directories & navigation · **Difficulty:** ★★★☆☆ · **Commands:** stat -c %h, ls -ld, for d in */

The link count of a directory (2nd column of `ls -ld`, or `stat -c %h`) is **2 + the number of
subdirectories** it contains: one link is its name in the parent, one is its own `.` and each
subdirectory has a `..` pointing to it. Hidden subdirectories count too, files don't.

For each directory directly inside `proj` (in the order of the glob `proj/*/`, hidden ones not
listed), print:

```
<name>: links=<L> subdirs=<L-2>
```

and finally one line `proj: links=<L> subdirs=<L-2>` for `proj` itself.
Use the link count: **don't** count the subdirectories by listing them.

---
Write your solution in `answer.sh`, then run `check 0217`.  
To experiment with the same test files the checker uses: `play 0217`.
