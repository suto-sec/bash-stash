# 1012 · tee in the middle of a pipeline

**Topic:** Pipes, xargs & command substitution · **Difficulty:** ★★★☆☆ · **Commands:** tee, sort, uniq

In **one pipeline**: read `palabras.txt`, save its **sorted** version into `ordenado.txt`
(with `tee`) and at the same time print on screen only the **unique** words (`uniq`) of that sorted list.

---
Write your solution in `answer.sh`, then run `check 1012`.  
To experiment with the same test files the checker uses: `play 1012`.
