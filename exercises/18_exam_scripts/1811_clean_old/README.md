# 1811 · Cleaning old temporary files

**Topic:** Exam-style scripts · **Difficulty:** ★★★★☆ · **Commands:** find -mtime, -delete, regex validation

Write `limpia.sh [DIR] [DAYS]` (defaults: current directory, 7) that deletes every **regular** file
under `DIR` whose name ends in `.tmp` or `~` and that was last modified **more than** `DAYS` days ago
(`find -mtime +DAYS`).

Print `Deleted <path>` for each deleted file (sorted), then `Deleted N files`.

- more than 2 arguments: usage on stderr, exit 1
- `DIR` not a directory: stderr, exit 2
- `DAYS` not a non-negative integer: stderr, exit 3

---
Write your solution in `answer.sh`, then run `check 1811`.  
To experiment with the same test files the checker uses: `play 1811`.
