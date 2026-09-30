# 0424 · archive_manifest.sh: reading tar's verbose listing

**Topic:** tar, gzip & compression · **Difficulty:** ★★★★☆ · **Commands:** tar -tvzf, find -printf, sort, exit codes

Write `archive_manifest.sh`:

```
archive_manifest.sh ARCHIVE
```

`tar -tvzf ARCHIVE` prints one line per entry, e.g.:

```
-rw-r--r-- diego/diego      1234 2024-05-01 10:23 src/main.c
```

(mode, owner/group, size in bytes, date, time, name — in that column order; the name may itself
contain spaces, but it is always the last field). Directory entries have a name ending in `/` and a
mode starting with `d`: ignore them. For every other (regular-file) entry, sorted by name, print:

```
NAME SIZE
```

Then print `Total: N files, B bytes` (`N` entries counted, `B` = sum of their sizes).

Errors (message on stderr): not exactly 1 argument → usage, exit **1**; `ARCHIVE` does not exist →
exit **2** (message includes `ARCHIVE`); `ARCHIVE` exists but `tar -tzf` fails on it → exit **3**
(message includes `ARCHIVE`).

---
Write your solution in `answer.sh`, then run `check 0424`.  
To experiment with the same test files the checker uses: `play 0424`.
