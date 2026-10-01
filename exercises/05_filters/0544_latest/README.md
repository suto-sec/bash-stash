# 0544 · latest.sh (newest log entries of a level)

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★★★☆ · **Commands:** grep -n, tail -n, tac, sed, [[ =~ ]]

Write `latest.sh`:

```
latest.sh LOG LEVEL [N]
```

`LOG` has lines `YYYY-MM-DD HH:MM:SS LEVEL message`, oldest first. `LEVEL` (third field) is
`DEBUG`, `INFO`, `WARN` or `ERROR`; the message may contain any of those words too (they don't count).

The script prints the **last `N`** entries (default **5**) whose level is exactly `LEVEL`,
**newest first**, each preceded by its line number in the file:

```
<line number>: <the whole line>
```

and then `Shown S of T LEVEL entries` (T = entries of that level in the whole file, S = those shown).

Errors (message on **stderr**, nothing on stdout), checked in this order:

- not 2 or 3 arguments: error and usage, exit **1**
- `LOG` is not a readable regular file: message with its name, exit **2**
- `LEVEL` is not one of `INFO`, `WARN`, `ERROR` (uppercase; `DEBUG` is not accepted): message, exit **3**
- `N` is not a positive integer: message, exit **4**
