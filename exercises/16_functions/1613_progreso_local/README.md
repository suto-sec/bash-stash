# 1613 · local keeps a name from leaking out

**Topic:** Functions · **Difficulty:** ★★★☆☆ · **Commands:** local, scope

The script starts with `n="sin datos"` — a status variable that has nothing to do with any loop
counter, but happens to share its name with one you are about to write.

Write a function `progreso` that, for the script's arguments (in order), prints one line
`paso N: valor V` (N = 1, 2, 3... ; V = the argument) using a variable **called `n`** as the
counter — declare it **local**, so it can never leak outside the function.

Write a function `sumar` that **echoes** the integer sum of its arguments.

The script must, in this exact order:

1. print `estado antes: $n`
2. call `progreso "$@"` directly (not inside `$( )`)
3. print `estado despues: $n` — it must still say `sin datos`
4. print `total: $(sumar "$@")`

---
Write your solution in `answer.sh`, then run `check 1613`.  
To experiment with the same test files the checker uses: `play 1613`.
