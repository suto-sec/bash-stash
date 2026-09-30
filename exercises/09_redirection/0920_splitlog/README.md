# 0920 · splitlog.sh (splitting a log by level)

**Topic:** Redirection: > >> 2> < << <<< · **Difficulty:** ★★★★☆ · **Commands:** grep -c, grep >>, mkdir -p, ${var,,}

Write `splitlog.sh`:

```
splitlog.sh LOG OUTDIR
```

Each line of `LOG` looks like `<date> <time> <LEVEL> <message...>` (fields separated by single spaces).
The **level** is the third field. The script **appends** the lines of `LOG` (in order, unchanged) to:

- `OUTDIR/error.log`, `OUTDIR/warn.log`, `OUTDIR/info.log`, `OUTDIR/debug.log` when the level is
  exactly `ERROR`, `WARN`, `INFO`, `DEBUG`
- `OUTDIR/other.log` for any other **non-empty** line (another level like `error` or `FATAL`, fewer
  fields...). Empty lines are ignored.

Existing files in `OUTDIR` keep their content (append!). A file is **only created if it receives at
least one line** (careful: `grep ... >> file` creates `file` even when nothing matches).
If `OUTDIR` does not exist, create it (with its parents) and print `Created <OUTDIR>` first.

Then print exactly (always the five lines, in this order, with the counts of **this** run):

```
error: <n>
warn: <n>
info: <n>
debug: <n>
other: <n>
Total: <T> lines
```

Errors (message on **stderr**): not exactly 2 arguments → usage, exit **1**; `LOG` is not a
readable regular file → exit **2**; `OUTDIR` exists and is not a directory → exit **3**.

---
Write your solution in `answer.sh`, then run `check 0920`.  
To experiment with the same test files the checker uses: `play 0920`.
