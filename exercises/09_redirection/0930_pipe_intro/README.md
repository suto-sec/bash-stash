# 0930 · Quick refresher: pipe

**Topic:** Redirection: > >> 2> < << <<< · **Difficulty:** ★☆☆☆☆ · **Commands:** |

A pipe `|` sends the output of the command on its left into the command on its right.

Print the number of lines of `/etc/passwd` using a pipe: `cat /etc/passwd` on the left and `wc -l` on the right. Print only the number.

Example: for a file with 25 lines, print `25`.

Hint: `command1 | command2`

---
Write your solution in `answer.sh`, then run `check 0930`.  
To experiment with the same test files the checker uses: `play 0930`.
