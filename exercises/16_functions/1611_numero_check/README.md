# 1611 · return status as a boolean check

**Topic:** Functions · **Difficulty:** ★★★☆☆ · **Commands:** return, $?, if func

Write a function `es_numero X` that **returns** (with explicit `return 0` / `return 1`, never
printing anything) 0 if `X` is a valid integer — an optional leading `-` followed by one or more
digits — and 1 otherwise.

For each script argument, using `if es_numero "$X"; then ... fi`, print `X: numero` or
`X: no numero`. At the end print `total: V numeros, I no numeros` (V + I must equal the number of
arguments).

---
Write your solution in `answer.sh`, then run `check 1611`.  
To experiment with the same test files the checker uses: `play 1611`.
