# 1517 · Parsing a CSV

**Topic:** Loops: for, while, until, read · **Difficulty:** ★★★☆☆ · **Commands:** while IFS=, read, tail -n +2

`alumnos.csv` has a header and lines `nombre,apellido,nota` (nota integer 0-10). Print:

1. every student as `APELLIDO, nombre: nota` (surname in uppercase: `${var^^}`), in file order
2. `---`
3. `aprobados: X, suspensos: Y`
4. `mejor: nombre apellido (nota)` for the best grade (the first one in the file if tied)

---
Write your solution in `answer.sh`, then run `check 1517`.  
To experiment with the same test files the checker uses: `play 1517`.
