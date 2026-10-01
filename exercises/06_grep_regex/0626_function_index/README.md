# 0626 · Where is each function defined?

**Topic:** grep & regular expressions · **Difficulty:** ★★★☆☆ · **Commands:** grep -nH -E, while IFS=: read, sort

The directory `scripts` contains bash scripts `*.sh` (names may contain spaces). A **function
definition** is a line that starts (column 1) with a name — a letter or `_` followed by letters, digits
or `_` — immediately followed by `()`. Indented definitions, comments, `function x {` and `name ()`
(with a space) do not count.

For every definition in the `.sh` files directly inside `scripts`, print

```
<name> <path>:<line number>
```

(`path` as `scripts/<file>`), sorted as `sort` sorts those lines. Function names are unique.
