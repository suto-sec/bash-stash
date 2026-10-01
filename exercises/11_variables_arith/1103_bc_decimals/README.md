# 1103 · Decimals with bc

**Topic:** Variables, arithmetic & environment · **Difficulty:** ★★☆☆☆ · **Commands:** bc, scale

Bash only does integer arithmetic. The file `notas.txt` contains one grade per line (integers 0-10).
Print:

1. the sum of the grades
2. the average with **2 decimals** (`scale=2` in `bc`)
3. `sqrt(2)` with 5 decimals

Hint: `paste -sd+ notas.txt | bc` sums a column.
