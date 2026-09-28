# 1209 · $$, subshells and source

**Topic:** Processes, jobs & signals · **Difficulty:** ★★★☆☆ · **Commands:** $$, $BASHPID, bash script, source script

The provided `pid.sh` prints `$$`. Print (only these words):

1. `same` or `different`: is the PID printed by `bash pid.sh` equal to your script's `$$`?
2. `same` or `different`: is the PID printed by `source pid.sh` equal to your `$$`?
3. `same` or `different`: inside `( ... )`, is `$BASHPID` equal to your `$$`?

Think about why: which one creates a new process?

---
Write your solution in `answer.sh`, then run `check 1209`.  
To experiment with the same test files the checker uses: `play 1209`.
