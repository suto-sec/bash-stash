# 0929 · Quick refresher: 2> (stderr to a file)

**Topic:** Redirection: > >> 2> < << <<< · **Difficulty:** ★☆☆☆☆ · **Commands:** 2>

Programs have two outputs: the normal one (stdout) and the one for errors (stderr). `2>` sends **only the errors** into a file.

Run `ls no_existe.txt` (that file does not exist, so `ls` complains) and send its error message into the file `error.txt`. Nothing is printed on the screen, and `error.txt` contains the message.

Hint: `command 2> file`

---
Write your solution in `answer.sh`, then run `check 0929`.  
To experiment with the same test files the checker uses: `play 0929`.
