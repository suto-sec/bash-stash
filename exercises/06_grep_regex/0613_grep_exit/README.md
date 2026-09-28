# 0613 · grep exit codes and -q

**Topic:** grep & regular expressions · **Difficulty:** ★★★☆☆ · **Commands:** grep -q, $?

For each of these three commands, print its exit code (`$?`) on its own line:

1. `grep -q` for the word `kernel` in `texto.txt`
2. `grep -q` for the word `zzzzz` in `texto.txt`
3. `grep -q` for `kernel` in a file that does **not** exist, `noexiste.txt` (hide the error message)

Then print `found` if `texto.txt` contains `shell`, or `not found` otherwise, using `grep -q` in an `if`.

---
Write your solution in `answer.sh`, then run `check 0613`.  
To experiment with the same test files the checker uses: `play 0613`.
