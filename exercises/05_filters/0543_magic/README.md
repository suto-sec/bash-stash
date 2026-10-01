# 0543 · magic.sh (file types from their first bytes)

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★★★☆ · **Commands:** od -An -tx1 -N, tr -d, case, [ -f -r ]

Write `magic.sh`:

```
magic.sh FILE...
```

For every argument, in order, it identifies the type of the file by its **first bytes** (its "magic
number"), **not** by its name, and prints `<argument>: <type>`:

| first bytes (hex) | type |
|-------------------|------|
| `89 50 4e 47` | `png` |
| `1f 8b` | `gzip` |
| `7f 45 4c 46` | `elf` |
| `25 50 44 46` (`%PDF`) | `pdf` |
| `50 4b 03 04` (`PK\003\004`) | `zip` |
| `23 21` (`#!`) | `script` |
| anything else (also empty or too short files) | `unknown` |

Use `od` to read the bytes (e.g. `od -An -tx1 -N4 file`).

An argument that is not a readable regular file is **skipped** with a message on **stderr**
including its name. At the end print `Identified K of N files`, where N = files examined (readable
regular files) and K = those whose type is not `unknown`.

Exit code: **1** (with usage on stderr) if there are no arguments; **2** if some argument was
skipped; **0** otherwise.
