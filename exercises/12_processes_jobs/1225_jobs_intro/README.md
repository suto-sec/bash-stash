# 1225 · jobs: listing background jobs

**Topic:** Processes, jobs & signals · **Difficulty:** ★☆☆☆☆ · **Commands:** jobs

`jobs` lists the background jobs of the current shell, one per line, with their number and state.

1. Start `sleep 0.3` in the background (`&`).
2. Start `sleep 0.4` in the background.
3. Immediately run `jobs` to print the list.

Expected output (the amount of spaces does not matter):

```
[1]-  Running                 sleep 0.3 &
[2]+  Running                 sleep 0.4 &
```

Run `jobs` right after starting the two commands, before they finish.

---
Write your solution in `answer.sh`, then run `check 1225`.  
To experiment with the same test files the checker uses: `play 1225`.
