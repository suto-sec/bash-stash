# 1220 · job_summary.sh (parametrised job exit codes)

**Topic:** Processes, jobs & signals · **Difficulty:** ★★★★☆ · **Commands:** &, wait, read, for, arithmetic

The fixture provides `codes.txt`: six lines, each a random exit code (0-9).

Write `job_summary.sh COUNT`. It starts, **in order**, `COUNT` background subshells, the i-th one being
`(exit CODE_i) &` where `CODE_i` is the i-th line of `codes.txt`. It then `wait`s for each one **in the
order they were started**, printing `job i: exit CODE_i`, and finally:

```
successes: <number of jobs that exited 0>
failures: <number of jobs that exited non-zero>
total: COUNT
```

- Not exactly 1 argument: usage on stderr, exit **1**.
- `COUNT` not an integer: error, exit **2**.
- `COUNT` outside `1..6`: error, exit **3**.

---
Write your solution in `answer.sh`, then run `check 1220`.  
To experiment with the same test files the checker uses: `play 1220`.
