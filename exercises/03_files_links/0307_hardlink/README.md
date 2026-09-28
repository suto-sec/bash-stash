# 0307 · Hard links

**Topic:** Files, copies & links · **Difficulty:** ★★☆☆☆ · **Commands:** ln, ls -l, link count

The directory `Datos` contains a file `borrador` and a directory `Stocks`.

1. Create a **hard link** named `Stocks/enlacefisico` pointing to `Datos/borrador`.
2. Create another hard link `Datos/copia_dura` to the same file.
3. Print the number of links of `Datos/borrador` using `stat -c %h`.

The checker also compares link counts of every file.

---
Write your solution in `answer.sh`, then run `check 0307`.  
To experiment with the same test files the checker uses: `play 0307`.
