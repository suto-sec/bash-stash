# 0617 · Only the first matches: -m

**Topic:** grep & regular expressions · **Difficulty:** ★★★☆☆ · **Commands:** grep -m, grep -n, head, cut

`app.log` is a log file. Print, separated by lines `---`:

1. the **first 3** lines that contain `ERROR` (exact case; fewer if there are fewer)
2. the **line number** (just the number) of the **first** line that contains `WARN` (exact case)
3. how many of the **first 10 lines** of the file contain `ERROR` (just the number)

"Contain" means anywhere in the line (`ERRORS` contains `ERROR`, `WARNING` contains `WARN`).
Hint: `grep -m`.

---
Write your solution in `answer.sh`, then run `check 0617`.  
To experiment with the same test files the checker uses: `play 0617`.
