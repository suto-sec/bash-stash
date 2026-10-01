# 0540 · splitter.sh (split into numbered pieces)

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★★★☆ · **Commands:** split -l -d -a, basename, ${var%.*}, wc -l -c

Write `splitter.sh`:

```
splitter.sh FILE LINES [PREFIX]
```

It splits `FILE` into pieces of `LINES` lines (the last one may be shorter) using `split`, in the
**current directory**, named `PREFIX000`, `PREFIX001`, ... (numeric suffixes of **3 digits**).
If `PREFIX` is not given, it is the base name of `FILE` without its last extension, followed by
`_` (`data/app log.txt` → `app log_`; `notes` → `notes_`).

Then it prints one line per piece, in order:

```
<piece>: <n> lines, <b> bytes
```

and finally `Total: <L> lines in <K> pieces` (an empty file produces no pieces: `Total: 0 lines in 0 pieces`).

Errors (message on **stderr**, nothing created), checked in this order:

- not 2 or 3 arguments: error message and usage, exit **1**
- `FILE` is not a readable regular file: message with its name, exit **2**
- `LINES` is not a positive integer (`1`, `25`...; not `0`, `-3`, `abc`): message, exit **3**
- a file named `PREFIX` followed by exactly three digits already exists (it would be
  overwritten): message, exit **4**
