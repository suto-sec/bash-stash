# 1023 · Files per directory from a list

**Topic:** Pipes, xargs & command substitution · **Difficulty:** ★★★☆☆ · **Commands:** xargs -d '\n', dirname, sort, uniq -c, sed

`paths.txt` contains file paths, one per line; some contain spaces and some have no directory part.
Print how many paths of the list there are **per directory**, as

```
<directory>: <count>
```

most frequent first; ties by directory in alphabetical order (as `sort` orders them). The directory of
a path is what `dirname` prints for it (`.` for a path without `/`).

Hint: `xargs -d '\n' dirname < paths.txt` (GNU `dirname` accepts several arguments), or `sed`.
