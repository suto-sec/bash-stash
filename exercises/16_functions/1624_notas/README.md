# 1624 · notas.sh: return for validity, echo for a letter grade

**Topic:** Functions · **Difficulty:** ★★★★☆ · **Commands:** return, $(func), exit codes

Write `notas.sh NOTA...`. Write `es_valida NOTA` which **returns** (explicit `return 0`/`return 1`,
no printing) 0 if NOTA is a valid integer from 0 to 100, 1 otherwise. Write `letra NOTA` which
**echoes** a single letter: `A` (>=90), `B` (>=80), `C` (>=70), `D` (>=60), `F` (otherwise).

For each argument: if invalid, print a message on stderr naming it (wording free) and skip it
(not fatal); otherwise print `NOTA: LETRA`.

At the end (only if at least one grade was valid) print
`TOTAL: V validas, promedio P, letra_prom L` (P = integer average of the valid grades, L =
`letra` applied to P).

Exit codes: 1 if there are no arguments at all (usage on stderr); 2 if there are arguments but
none is valid; 0 otherwise.
