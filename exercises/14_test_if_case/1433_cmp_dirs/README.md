# 1433 · cmp_dirs.sh: comparing two directories

**Topic:** test, if & case · **Difficulty:** ★★★★☆ · **Commands:** test -f -e -nt -ef, cmp -s, basename, exit codes

Write `cmp_dirs.sh dir1 dir2`, which compares the **regular files** directly inside two directories
(not recursive, hidden files ignored).

First, for every regular file `name` in `dir1` (order of the `*` glob), print the first that applies:

| situation | line |
|-----------|------|
| `dir2/name` does not exist | `only in <dir1>: name` |
| `dir2/name` exists but is not a regular file | `not comparable: name` |
| same content (`cmp -s`) | `same: name` |
| `dir1/name` is newer (`-nt`) | `newer in <dir1>: name` |
| `dir2/name` is newer | `newer in <dir2>: name` |
| otherwise (different content, same age) | `differs: name` |

Then, for every regular file `name` in `dir2` (glob order) for which **nothing** called `name`
exists in `dir1`, print `only in <dir2>: name`. (Entries of `dir1` that are not regular files are
ignored.) `<dir1>` and `<dir2>` are the arguments as given.

Finally print `Same: S, different: D, only in <dir1>: A, only in <dir2>: B` (different = newer,
differs and not comparable).

Exit codes:

| situation | exit |
|-----------|------|
| everything the same (D, A and B are 0) | 0 |
| some difference | 1 |
| not exactly 2 arguments (usage on stderr) | 2 |
| `dir1` is not a directory (stderr, name it) | 3 |
| `dir2` is not a directory (stderr, name it) | 4 |
| both are the same directory (`-ef`) (stderr) | 5 |

---
Write your solution in `answer.sh`, then run `check 1433`.  
To experiment with the same test files the checker uses: `play 1433`.
