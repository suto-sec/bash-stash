# 0566 · sed: basic s/// substitution

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★☆☆☆☆ · **Commands:** sed s///

`sed 's/old/new/'` replaces the **first** `old` of every line by `new`.

For the file `frase.txt`, print its content replacing the first `hola` of each line by `adios` (the file is not modified, `sed` just prints).

Example: the line `hola luis hola ana` becomes `adios luis hola ana`.

Hint: `sed 's/hola/adios/' file`
