# 0902 · Separating stdout and stderr

**Topic:** Redirection: > >> 2> < << <<< · **Difficulty:** ★☆☆☆☆ · **Commands:** 2>, >

Run `ls` on the files listed in `nombres.txt` (some of them don't exist), with a single `ls` command
whose arguments are `$(cat nombres.txt)`:

- normal output must go to `ok.txt`
- error messages must go to `errores.txt`

Then print the number of lines of each file: `ok: N` and `errores: M`.

---
Write your solution in `answer.sh`, then run `check 0902`.  
To experiment with the same test files the checker uses: `play 0902`.
