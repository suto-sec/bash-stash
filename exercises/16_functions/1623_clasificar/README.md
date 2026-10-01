# 1623 · clasificar.sh: classifying numbers via a sourced library

**Topic:** Functions · **Difficulty:** ★★★★☆ · **Commands:** source, functions, [[ =~ ]]

The provided file `lib_num.sh` defines `es_numero X` (**returns** 0 if X is a valid integer,
optionally signed) and `es_par X` (**returns** 0 if X is even; only called with a valid integer).

Write `clasificar.sh NUM...`: **source** `lib_num.sh` (don't redefine its functions) and, for each
argument, print:

- `X: no numero` if `es_numero` fails
- `X: cero` if X equals 0
- `X: positivo par` / `X: positivo impar` / `X: negativo par` / `X: negativo impar` otherwise

Finally print `TOTAL: P positivos, N negativos, Z ceros, I invalidos`.

Errors: no arguments at all → usage on stderr, exit 1.
