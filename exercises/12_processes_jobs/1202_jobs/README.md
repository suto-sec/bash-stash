# 1202 · The jobs table

**Topic:** Processes, jobs & signals · **Difficulty:** ★★☆☆☆ · **Commands:** jobs, kill %N

1. Start three background jobs: `sleep 101`, `sleep 102`, `sleep 103` (in that order).
2. Print the job table with `jobs`.
3. Kill job **number 2** using job syntax (`kill %2`), then `wait` for it (hide wait's output).
4. Print `jobs` again: job 2 is gone, and notice how the `+` (current) and `-` (previous) marks work.
5. Kill the remaining jobs (`%1 %3`) and wait for them.

---
Write your solution in `answer.sh`, then run `check 1202`.  
To experiment with the same test files the checker uses: `play 1202`.
