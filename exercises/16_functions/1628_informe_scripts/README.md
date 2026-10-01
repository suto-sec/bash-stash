# 1628 · informe_scripts.sh: die plus a per-file function

**Topic:** Functions · **Difficulty:** ★★★★☆ · **Commands:** die/usage pattern, find -print0, while read -r -d '', $(func), read

Write `informe_scripts.sh DIR`. Write a helper `die CODE MESSAGE...` (prints `ERROR: MESSAGE` on
stderr, exits the script with CODE) and use it for every validation:

| situation | exit |
|-----------|------|
| not exactly 1 argument (show the usage) | 1 |
| DIR is not a directory (name it) | 2 |

Write a function `analizar ARCHIVO` that **echoes** two words on one line: `exec` or `noexec`
(whether the file has any execute bit set) and `shebang` or `sin-shebang` (whether its first line
starts with `#!`, check with `head -n 1`).

Recursively visit every regular file under DIR whose name ends in `.sh`, safely and sorted
(`find DIR -type f -name '*.sh' -print0 | sort -z | while IFS= read -r -d '' f; do ... done`, names
may contain spaces). For each one, call `analizar "$f"` and capture its two words with
`read -r e s <<< "$(analizar "$f")"`; print `FILE: E, S`.

Finally print `TOTAL: N scripts, E ejecutables, S con shebang`.
