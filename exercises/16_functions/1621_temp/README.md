# 1621 · temp.sh: a die helper dispatching to two functions

**Topic:** Functions · **Difficulty:** ★★★★☆ · **Commands:** die/usage pattern, case, $(func)

Write `temp.sh UNIDAD VALOR` (UNIDAD is `C` or `F`, case-sensitive; VALOR is an integer,
possibly negative). Write a helper `die CODE MESSAGE...` (prints `ERROR: MESSAGE` on stderr and
exits the script with CODE) and use it for every validation:

| situation | exit |
|-----------|------|
| not exactly 2 arguments (show the usage) | 1 |
| UNIDAD is neither `C` nor `F` (name it) | 2 |
| VALOR is not a valid integer (name it) | 3 |

Write `c_to_f` and `f_to_c` (integer arithmetic, truncating like `$(( ))`) and a function
`convertir UNIDAD VALOR` that **echoes** the converted value, dispatching with a `case`. Print
`VALOR UNIDAD = R OTRA` (OTRA is the other unit's letter).

---
Write your solution in `answer.sh`, then run `check 1621`.  
To experiment with the same test files the checker uses: `play 1621`.
