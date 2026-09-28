# 1005 · The biggest files

**Topic:** Pipes, xargs & command substitution · **Difficulty:** ★★☆☆☆ · **Commands:** ls -S, du, sort -n, head

Print the names of the **3 biggest** regular files of the directory `datos` (biggest first, only
names). Then `---`, then the 2 biggest subdirectories of `datos` (by `du -s` size, biggest first,
as `du -s` prints them: `size<TAB>path`).

---
Write your solution in `answer.sh`, then run `check 1005`.  
To experiment with the same test files the checker uses: `play 1005`.
