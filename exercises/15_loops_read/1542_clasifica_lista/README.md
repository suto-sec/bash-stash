# 1542 · Loop + case: per-item dispatch

**Topic:** Loops: for, while, until, read · **Difficulty:** ★★★☆☆ · **Commands:** while read, case

`entradas.txt` has one file name per line (names may contain spaces; they are plain names, not
paths). Read it line by line and, for each name, use a `case` on its extension to dispatch it into a
category:

- `.sh` -> `scripts`
- `.txt` or `.md` -> `docs`
- `.jpg`, `.png` or `.gif` -> `imagenes`
- anything else (including no extension) -> `otros`

Print `NAME -> CATEGORIA` for every line, in file order. After the loop, print every category that
got at least one entry, **sorted alphabetically**, as `CATEGORIA: N`. Finally print `TOTAL: T`
(T = number of lines processed).
