# 1207 · Querying processes with ps

**Topic:** Processes, jobs & signals · **Difficulty:** ★★★☆☆ · **Commands:** ps -u, ps -p, ps -o, ps -C

The system has fake sessions of `luke`, `sally`, `rod` and `pruiz`. Print, separated by `---`:

1. the number of processes owned by `luke` (`ps -u luke`, no header: `--no-headers` or `-o pid=`)
2. the user and command of process **1** (`ps -o user=,comm= -p 1`)
3. the users that own a process called `sleep`, sorted and unique (`ps -C sleep -o user=`),
   excluding `alumno`

---
Write your solution in `answer.sh`, then run `check 1207`.  
To experiment with the same test files the checker uses: `play 1207`.
