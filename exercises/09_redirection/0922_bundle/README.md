# 0922 · bundle.sh (joining files with headers)

**Topic:** Redirection: > >> 2> < << <<< · **Difficulty:** ★★★★☆ · **Commands:** { ...; } >> file, : > file, test -ef, wc -l <

Write `bundle.sh`:

```
bundle.sh OUT FILE...
```

It writes into `OUT` (created, or **emptied** if it exists), for each `FILE` in order, a header line
`==> <FILE> <==` followed by the content of `FILE`. A `FILE` may be given more than once.

- A `FILE` that is not a readable regular file: message on stderr naming it; it is skipped
  (nothing about it goes into `OUT`) and the final exit code is **2**.
- For each file added, print on stdout `added <FILE> (<n> lines)` (n = lines of that file).
- Finally print `<k> files, <L> lines written to <OUT>` (`k` files added, `L` = lines of `OUT`).

Errors (message on **stderr**), checked **before** writing anything:

| situation | exit |
|-----------|------|
| fewer than 2 arguments (show usage) | 1 |
| some `FILE` is the same file as `OUT` (`[ FILE -ef OUT ]`, e.g. `out.txt` and `./out.txt`); `OUT` must stay untouched | 3 |
| `OUT` cannot be written (e.g. its directory does not exist) | 4 |

All files end with a newline. Names may contain spaces.

---
Write your solution in `answer.sh`, then run `check 0922`.  
To experiment with the same test files the checker uses: `play 0922`.
