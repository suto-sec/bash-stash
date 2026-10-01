# 0746 · big_recent.sh: files that are both new and big

**Topic:** find · **Difficulty:** ★★★★☆ · **Commands:** find -newer, -size, script argument, summary line

Write `big_recent.sh`:

```
big_recent.sh [directory]
```

Prints, **sorted**, one per line, the paths of every **regular file** under `directory` (default:
the current directory, searched recursively) that is **newer than** `directory/.marca` **and**
whose size is **greater than 1 MiB** (`-size +1M`). After the list, print exactly:

```
Total: N files
```

where `N` is the number of such files. No argument-count validation is required: just default to
`.` when no argument is given. `.marca` always exists in the tests.
