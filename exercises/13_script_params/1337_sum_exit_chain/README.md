# 1337 · Simulating a command chain that stops at the first failure

**Topic:** Script parameters & exit codes · **Difficulty:** ★★★☆☆ · **Commands:** for, break, exit

The script receives a sequence of exit codes (integers 0-255) as arguments, simulating the exit
status of commands run one after another. Process them **in order**: for each one print
`paso K: CODE (ok)` if CODE is 0, or `paso K: CODE (fallo)` otherwise; **stop processing** (as a real
`cmd1 && cmd2 && ...` chain would) as soon as one is not 0 — no later argument is printed.

If it never stopped early, print `todo ok`; otherwise print `detenido en paso K`. Finally, always
print `pasos_ejecutados: K` (the number of steps actually printed). With no arguments, print
`todo ok` and `pasos_ejecutados: 0`.

---
Write your solution in `answer.sh`, then run `check 1337`.  
To experiment with the same test files the checker uses: `play 1337`.
