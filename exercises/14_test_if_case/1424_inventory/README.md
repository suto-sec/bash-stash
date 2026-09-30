# 1424 · inventory.sh: classifying directory entries

**Topic:** test, if & case · **Difficulty:** ★★★★☆ · **Commands:** test -L -e -d -f -x -s, ls -A, while read, exit codes

Write `inventory.sh`:

```
inventory.sh [directory]
```

For every entry directly inside `directory` (default: the current directory), **hidden ones
included** (not `.` and `..`), in the order `ls -A` lists them, print `[<tag>] <name>` with the tag
given by the **first** matching rule:

| rule | tag |
|------|-----|
| symbolic link whose target does not exist | `broken link` |
| any other symbolic link | `link` |
| directory | `dir` |
| regular file you can execute | `exec` |
| empty regular file | `empty` |
| other regular file | `file` |
| anything else (pipes, devices...) | `other` |

Finally print `Total: N (dirs D, files F, links L, other O)` where `files` counts the `exec`,
`empty` and `file` entries and `links` both kinds of links.

Errors (message on **stderr**, wording free), checked in this order:

| error | exit |
|-------|------|
| more than one argument (show the usage) | 1 |
| `directory` does not exist (name it) | 2 |
| it is not a directory (name it) | 3 |
| you cannot read it or enter it (name it) | 4 |

---
Write your solution in `answer.sh`, then run `check 1424`.  
To experiment with the same test files the checker uses: `play 1424`.
