# 1211 · Counting running background jobs

**Topic:** Processes, jobs & signals · **Difficulty:** ★★★☆☆ · **Commands:** &, jobs -r, kill %N, wait

1. Start three background jobs, in order: `sleep 101`, `sleep 102`, `sleep 103`.
2. Print the number of **running** background jobs (`jobs -r | wc -l`).
3. Kill jobs `%1` and `%3` (job-spec syntax) and `wait` for them (hide messages).
4. Print the number of running background jobs again.
5. Kill the remaining job (`%2`), `wait` for it, and print the number of running background jobs
   a third time.

---
Write your solution in `answer.sh`, then run `check 1211`.  
To experiment with the same test files the checker uses: `play 1211`.
