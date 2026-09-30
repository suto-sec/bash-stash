# 1524 · select over a dynamic list

**Topic:** Loops: for, while, until, read · **Difficulty:** ★★★☆☆ · **Commands:** select, $REPLY, break, wc -l

Show a menu with `select f in *.txt quit` (the `.txt` files of the current directory in glob order,
plus a last option `quit`). The menu and the `PS3` prompt go to stderr; the choices come from stdin.
For each choice:

- a file: print `NAME: L lines`
- `quit`: print `bye` and leave the loop
- an invalid number or text (`$f` is empty): print `invalid choice: X`, where X is what the user
  typed (`$REPLY`)

After the loop (by `quit` or because stdin ended) print `shown K files` (K = how many times a file
was shown). File names may contain spaces.

---
Write your solution in `answer.sh`, then run `check 1524`.  
To experiment with the same test files the checker uses: `play 1524`.
