# 0646 · grep -E: extended regex basics

**Topic:** grep & regular expressions · **Difficulty:** ★☆☆☆☆ · **Commands:** grep -E, |

With `grep -E` (extended regular expressions) the `|` symbol means "or".

Print the lines of `mascotas.txt` that contain `gato` **or** `perro`, with a single `grep -E`.

Example: if `mascotas.txt` contains `gato negro`, `pez rojo`, `perro blanco`, the output is `gato negro` and `perro blanco`.

Hint: `grep -E 'one|two' file`

---
Write your solution in `answer.sh`, then run `check 0646`.  
To experiment with the same test files the checker uses: `play 0646`.
