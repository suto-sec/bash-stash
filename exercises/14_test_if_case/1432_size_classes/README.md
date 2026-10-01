# 1432 · size_classes.sh: small, ok and big files

**Topic:** test, if & case · **Difficulty:** ★★★★☆ · **Commands:** test -f -r -s -gt -lt, stat -c %s, [[ =~ ]], exit codes

Write `size_classes.sh`:

```
size_classes.sh directory min max
```

For every **regular file** directly inside `directory` (not hidden, in the order of the `*` glob;
anything that is not a regular file is ignored) print `<name>: <class> (<size> bytes)` with the class
given by the **first** matching rule:

| rule | class |
|------|-------|
| you cannot read it | `unreadable` |
| it is empty | `empty` |
| size < `min` | `small` |
| size > `max` | `big` |
| otherwise | `ok` |

(size in bytes, e.g. `stat -c %s`; `<name>` without the directory). Finally print
`Files: N (unreadable U, empty E, small S, ok O, big B)`.

Errors (message on **stderr**, wording free), checked in this order:

| error | exit |
|-------|------|
| not exactly 3 arguments (show the usage) | 1 |
| `directory` is not a directory (name it) | 2 |
| `min` or `max` is not a non-negative integer (digits only) (name it) | 3 |
| `min` > `max` | 4 |
