# 0910 · File descriptors with exec

**Topic:** Redirection: > >> 2> < << <<< · **Difficulty:** ★★★★☆ · **Commands:** exec 3>, >&3, exec 3>&-, exec 4<, read -u

Using **custom file descriptors**:

1. open `salida.txt` for writing on fd 3 (`exec 3> salida.txt`)
2. write the lines `uno` and `dos` to fd 3
3. close fd 3
4. open `entrada.txt` for reading on fd 4 and read **its first two lines** with `read -u 4`
   (or `read <&4`); print them in reverse order (second line first)
5. close fd 4

---
Write your solution in `answer.sh`, then run `check 0910`.  
To experiment with the same test files the checker uses: `play 0910`.
