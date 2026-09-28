# 0909 · Writing error messages to stderr

**Topic:** Redirection: > >> 2> < << <<< · **Difficulty:** ★★☆☆☆ · **Commands:** >&2, exit

Scripts must write errors to **stderr**. The script receives a file name as argument:

- if the file exists, print its number of lines (just the number) on **stdout** and exit `0`
- if it doesn't, print `Error: <name> not found` on **stderr** and exit `1`

The checker compares stdout, stderr and exit code exactly.

---
Write your solution in `answer.sh`, then run `check 0909`.  
To experiment with the same test files the checker uses: `play 0909`.
