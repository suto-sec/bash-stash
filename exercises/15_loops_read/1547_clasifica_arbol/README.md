# 1547 · clasifica_arbol.sh: dispatching find results with case

**Topic:** Loops: for, while, until, read · **Difficulty:** ★★★★☆ · **Commands:** find -print0, sort -z, while read -r -d '', case

Write `clasifica_arbol.sh DIR`. Recursively visit every **regular file** under DIR (any depth,
hidden included), safely (`find DIR -type f -print0 | sort -z | while IFS= read -r -d '' f; do
... done`, names may contain spaces), and classify each one with a `case` on its extension:

- `*.sh` -> `scripts`
- `*.txt`, `*.md` -> `docs`
- `*.jpg`, `*.png` -> `imagenes`
- anything else (including no extension) -> `otros`

For every category that got at least one file, **sorted alphabetically**, print
`CATEGORIA: N archivos, S bytes` (S = sum of sizes in that category). Finally print
`TOTAL: F archivos, S bytes` over everything.

Errors (stderr, wording free): not exactly 1 argument -> usage, exit **1**; DIR is not a directory
-> exit **2** (name it).

---
Write your solution in `answer.sh`, then run `check 1547`.  
To experiment with the same test files the checker uses: `play 1547`.
