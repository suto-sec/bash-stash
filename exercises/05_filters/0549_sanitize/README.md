# 0549 · sanitize.sh (CR, tabs and trailing spaces)

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★★★☆ · **Commands:** grep -c, tr -d, sed -i, od -c

Write `sanitize.sh`:

```
sanitize.sh FILE...
```

It cleans every file **in place** (keeping its permissions), in argument order:

1. removes every carriage return (`\r`, byte 13: files written on Windows),
2. replaces every TAB with **4 spaces**,
3. removes the spaces at the end of every line.

Before changing a file, count its **lines** that: contain a CR (`C`), contain a TAB (`T`), and
end with spaces or TABs once the CRs are removed (`S`). Then print

```
<name>: C CR, T tabs, S trailing
```

or `<name>: clean` if the three counts are 0 (the file is not touched). At the end print
`Fixed F of N files` (N = files examined, F = those that were not clean).

Arguments that are not readable and writable regular files are skipped with a message on
**stderr** that includes the name. Exit code: **1** (with usage) if there are no arguments; **2** if
some argument was skipped; **0** otherwise.

Tip: `od -c file` shows the `\r` and `\t` that `cat` hides.
