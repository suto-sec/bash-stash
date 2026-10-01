# 1327 · chext.sh: changing file extensions

**Topic:** Script parameters & exit codes · **Difficulty:** ★★★★☆ · **Commands:** ${3:-.}, [[ =~ ]], test -f -e, mv, exit codes

Write `chext.sh`:

```
chext.sh old new [directory]
```

It renames every **regular file** directly inside `directory` (default: the current directory; not
recursive, hidden files excluded) whose name ends in `.old` so that it ends in `.new` instead
(`report.old` → `report.new`). Extensions are given without the dot and are case-sensitive.

For each candidate, in the order of the `*.old` glob:

- if a file called `<base>.new` already exists there: do not touch it, print
  `skipped: <name> (<base>.new exists)` on **stderr**
- otherwise rename it and print `renamed: <name> -> <base>.new` on stdout

(names without the directory). Finally print `Renamed R, skipped S` on stdout and exit 0.

Errors, checked in this order (message on **stderr**, wording free, nothing renamed):

| error | exit |
|-------|------|
| not 2 or 3 arguments (show the usage) | 1 |
| an extension is empty or has characters other than letters and digits (name it) | 2 |
| `old` and `new` are the same | 3 |
| `directory` does not exist (name it) | 4 |
| `directory` is not a directory (name it) | 5 |
