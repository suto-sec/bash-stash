# 1423 · Is the directory empty?

**Topic:** test, if & case · **Difficulty:** ★★★☆☆ · **Commands:** test -e -d -r -x, ls -A, wc -l

For each argument print exactly one line, the first that applies:

- `<name>: not found` (does not exist)
- `<name>: not a directory`
- `<name>: no access` (a directory you cannot both read and enter)
- `<name>: empty` (no entries at all, hidden ones included)
- `<name>: N entries` (number of entries, **hidden ones included**, not counting `.` and `..`)

(A symbolic link to a directory is treated as the directory.)

---
Write your solution in `answer.sh`, then run `check 1423`.  
To experiment with the same test files the checker uses: `play 1423`.
