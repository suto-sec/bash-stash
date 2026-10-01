# 0629 · wsearch.sh (whole-word search in text files)

**Topic:** grep & regular expressions · **Difficulty:** ★★★★☆ · **Commands:** grep -r -c -i -w, --include, sort -k, ${var##*:}

Write `wsearch.sh`:

```
wsearch.sh WORD [DIR]
```

It searches the regular files whose name ends in `.txt` under `DIR` (default: the current directory
`.`; recursively) for lines that contain `WORD` as a **whole word** (as `grep -w`), in **any case**.
For every file with at least one matching line print

```
<number of matching lines> <path>
```

where `path` is the path as found under `DIR` (e.g. `docs/sub dir/a.txt`, `./notes.txt`), sorted by
number descending and then by path ascending (as `sort` orders them). Finally print the summary

```
<total matching lines> lines in <number of files> files
```

Errors (message on **stderr**):

| situation | exit |
|-----------|------|
| no arguments or more than 2 (show the usage) | 1 |
| `WORD` is not made only of letters and digits (mention it) | 2 |
| `DIR` is not a directory (mention it) | 3 |
| no match at all: print just the summary `0 lines in 0 files` on stdout | 4 |
