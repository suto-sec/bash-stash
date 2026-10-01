# 1530 · inventario.sh: validating a ;-separated file

**Topic:** Loops: for, while, until, read · **Difficulty:** ★★★★☆ · **Commands:** while IFS=';' read -r, [[ =~ ]], counters, exit codes

Write `inventario.sh FILE [MIN]`. FILE has a header line (always skipped, whatever it contains) and
then lines `PRODUCT;QUANTITY;PRICE`. A line is **valid** when it has exactly 3 fields, PRODUCT is not
empty (it may contain spaces) and QUANTITY and PRICE are non-negative integers (digits only).
MIN (default `5`) is the low-stock threshold.

For each valid line, in file order, print

```
PRODUCT: QUANTITY x PRICE = VALUE
```

(VALUE = QUANTITY × PRICE), adding ` (low stock)` at the end when QUANTITY < MIN. For each invalid
line print `line N: invalid` on **stderr** (N = line number in the file; the header is line 1).
Finally print:

```
TOTAL: P products, U units, V euros, L low
```

Exit codes: 0 if all lines were valid, **4** if there was some invalid line (after printing
everything). Errors that stop the script before reading (stderr, wording free):
0 or more than 2 arguments → **1** (show the usage); FILE not a readable regular file → **2** (name
it); MIN not a non-negative integer → **3** (name it).
