# 0737 · buscatexto.sh: which files mention a word

**Topic:** find · **Difficulty:** ★★★★☆ · **Commands:** find -readable, grep -ciw, sort -k, exit codes

Write `buscatexto.sh`:

```
buscatexto.sh WORD DIR [EXT]
```

It searches the **regular files** under `DIR` (recursively) — only those whose name ends in `.EXT` if
`EXT` is given (without the dot, e.g. `log`) — for lines containing `WORD` as a **whole word** in **any
case** (`grep -iw`). For every file with at least one such line print

```
<count> <path>
```

(count = number of matching lines), sorted by count (descending) and then by path; paths as `find`
prints them. Finally print `WORD: L lines in N files` (WORD as given).

Files you **cannot read** are silently ignored (no message at all: stderr must stay empty).

Exit code: **1** if nothing was found (the summary `WORD: 0 lines in 0 files` is still printed),
0 otherwise. Checks, **in this order** (stderr, wording free):

- fewer than 2 or more than 3 arguments, or `WORD` empty: usage, exit **2**
- `DIR` is not a directory: exit **3**

Careful: `grep -c` with a single file prints only the number, with several files it prints
`file:number`. Names may contain spaces.
