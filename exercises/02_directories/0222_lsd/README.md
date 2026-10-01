# 0222 · lsd.sh: listing several directories

**Topic:** Directories & navigation · **Difficulty:** ★★★★☆ · **Commands:** ls -p, ls -A, grep -c, for "$@", shift, exit codes

Write `lsd.sh`:

```
lsd.sh [-a] DIR...
```

For each `DIR` argument, in order:

- if it is a directory, print a header line `DIR:` (as given), then its entries **directly inside**, one
  per line, **indented with two spaces**, in the order `ls` gives them, with a `/` appended to the
  directories (that is what `ls -p` does). Hidden entries are listed only with `-a` (never `.` and
  `..`: think `ls -A`). Then a line `  (D dirs, F other)` with the number of listed entries that are
  directories and the number of the rest.
- if it is not a directory: print `lsd.sh: cannot list 'DIR'` on **stderr** and go on with the next one.

After all of them print `Listed N directories, E errors`.

- `-a` is only recognised as the **first** argument.
- no `DIR` given (no arguments, or only `-a`): usage on stderr, exit **1**
- exit **2** if at least one argument could not be listed, **0** otherwise

The example below is `lsd.sh -a docs empty nothing`:

```
docs:
  .config/
  guide.pdf
  images/
  my notes.txt
  (2 dirs, 2 other)
empty:
  (0 dirs, 0 other)
Listed 2 directories, 1 errors
```
