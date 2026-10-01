# 0926 · Quick refresher: > (stdout to a file)

**Topic:** Redirection: > >> 2> < << <<< · **Difficulty:** ★☆☆☆☆ · **Commands:** >

`>` sends the output of a command into a file instead of the screen. If the file already exists, it is **overwritten**.

Save the output of `echo hola` into the file `saludo.txt`. The file already exists with some old content: it must end up containing only `hola`. Nothing is printed on the screen.

Hint: `command > file`

---
Write your solution in `answer.sh`, then run `check 0926`.  
To experiment with the same test files the checker uses: `play 0926`.
