# 1036 · tee: save and print at the same time

**Topic:** Pipes, xargs & command substitution · **Difficulty:** ★☆☆☆☆ · **Commands:** tee

`tee file` copies what it receives to the file **and** to the screen, so you save a result and also see it.

The file `entrada.txt` contains one line of text. Send it through `cat` and then `tee salida.txt`, so the line is printed on the screen and also saved in `salida.txt`.

Example: if `entrada.txt` contains `hola mundo`, the screen shows `hola mundo` and `salida.txt` also contains `hola mundo`.

Hint: `cat file | tee other_file`

---
Write your solution in `answer.sh`, then run `check 1036`.  
To experiment with the same test files the checker uses: `play 1036`.
