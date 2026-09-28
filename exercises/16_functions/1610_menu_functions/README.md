# 1610 · A menu program built from functions

**Topic:** Functions · **Difficulty:** ★★★☆☆ · **Commands:** functions, while read, case

A tiny interactive note keeper. Commands come from stdin, one per line:

- `add TEXT...` → append TEXT to `notas.txt` and print `added (N notes)`
- `list` → print the notes numbered `N) text` (or `no notes` if the file is missing/empty)
- `del N` → delete note N (`sed -i "Nd"`), print `deleted N`, or `no such note` if out of range
- `quit` → print `bye` and stop
- anything else → `unknown command: <cmd>` on stderr, continue

Implement each command as a function. The checker compares stdout and the final `notas.txt`.

---
Write your solution in `answer.sh`, then run `check 1610`.  
To experiment with the same test files the checker uses: `play 1610`.
