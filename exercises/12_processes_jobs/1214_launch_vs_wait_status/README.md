# 1214 · $? right after & vs. after wait

**Topic:** Processes, jobs & signals · **Difficulty:** ★★★☆☆ · **Commands:** &, $!, wait, $?

1. Run `(exit 5) &` in the background; **immediately** print `$?` (the exit status of the `&` command
   itself, i.e. of *launching* it) as `launch: <code>`.
2. Save its PID with `$!`, `wait` for it and print `wait: <code>` with the status `wait` returns.
3. Repeat both steps for `(sleep 0.1; exit 0) &`.

Think about it: starting a job in the background always "succeeds" immediately; the job's own result
only becomes known once you `wait` for it.

---
Write your solution in `answer.sh`, then run `check 1214`.  
To experiment with the same test files the checker uses: `play 1214`.
