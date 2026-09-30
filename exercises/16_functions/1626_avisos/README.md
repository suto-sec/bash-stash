# 1626 · A shared helper called at several validation points

**Topic:** Functions · **Difficulty:** ★★★☆☆ · **Commands:** function, >&2, global counter

The script receives arguments of the form `NOMBRE=EDAD`. Write a helper `queja MSG...` that prints
MSG to **stderr** (wording free, but it must name the offending argument) and increments a global
counter `ERRORES` — it must **not** exit. Call `queja` at each of these validation points, in order,
for every argument (stop checking that argument at the first failure and move to the next one):

1. the argument must contain **exactly one** `=` with a non-empty part before it (NOMBRE) — otherwise
   `queja`
2. the part after `=` (EDAD) must be made only of digits — otherwise `queja`
3. EDAD must be between 0 and 120 (inclusive) — otherwise `queja`

When an argument passes all three checks, print `NOMBRE: EDAD anios`. Finally print
`validos: V, avisos: ERRORES`. Exit 0 if `ERRORES` is 0, 1 otherwise.

---
Write your solution in `answer.sh`, then run `check 1626`.  
To experiment with the same test files the checker uses: `play 1626`.
