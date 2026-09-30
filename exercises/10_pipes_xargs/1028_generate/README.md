# 1028 · generate.sh (files from a template)

**Topic:** Pipes, xargs & command substitution · **Difficulty:** ★★★★☆ · **Commands:** while read, sed s///g, $( ), mkdir, exit codes

Write `generate.sh`:

```
generate.sh TEMPLATE LIST OUTDIR
```

`TEMPLATE` is a text file that may contain the placeholders `{{NAME}}` and `{{N}}` (several times).
`LIST` contains one name per line. For every line of `LIST`, in order:

- empty lines are ignored silently;
- a name is **valid** if it is made only of letters, digits, spaces, `_` and `-`. An invalid name
  prints `invalid name: <name>` on **stderr** and is skipped;
- a valid name that was already generated before prints `duplicate: <name>` on **stderr** and is
  skipped;
- otherwise the script creates `OUTDIR/<name>.txt` (overwriting it if it exists) with the content of
  `TEMPLATE` where every `{{NAME}}` is replaced by the name and every `{{N}}` by the number of this
  file (1 for the first file generated, 2 for the second...; skipped names don't take a number),
  and prints `generated: OUTDIR/<name>.txt` on stdout (`OUTDIR` exactly as given).

If `OUTDIR` does not exist, create it first and print `Created OUTDIR`. At the end print
`Generated <N> files, <S> skipped`. Exit code 0 (even if some names were skipped).

Validation, in this order (message on **stderr**, nothing is created):

- not exactly 3 arguments: usage, exit **1**
- `TEMPLATE` is not a readable regular file: exit **2**
- `LIST` is not a readable regular file: exit **3**
- `OUTDIR` exists but is not a directory: exit **4**

---
Write your solution in `answer.sh`, then run `check 1028`.  
To experiment with the same test files the checker uses: `play 1028`.
