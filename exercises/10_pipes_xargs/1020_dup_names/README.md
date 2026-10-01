# 1020 · Same name, different folder

**Topic:** Pipes, xargs & command substitution · **Difficulty:** ★★★☆☆ · **Commands:** find, sed, sort, uniq -c, grep -v

Under `tree` there are regular files in several subdirectories, and some file **names** (the part
after the last `/`) appear in more than one directory.

Print one line per name that appears **more than once** (only regular files count: a directory
with a repeated name does not), sorted alphabetically by name:

```
NAME: N copies
```

and finally a line `D repeated names`. Names may contain spaces.

Hint: `find ... | sed 's#.*/##' | sort | uniq -c` does most of the work.
