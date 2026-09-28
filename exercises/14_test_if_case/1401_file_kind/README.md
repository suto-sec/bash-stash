# 1401 · What is it?

**Topic:** test, if & case · **Difficulty:** ★☆☆☆☆ · **Commands:** if, test -e -f -d -L

The script receives a path as its only argument and prints exactly one of:

- `<path> is a symbolic link` (check this first: `-L`)
- `<path> is a directory`
- `<path> is a regular file`
- `<path> is something else` (exists, but none of the above, e.g. `/dev/null`)
- `<path> does not exist`

---
Write your solution in `answer.sh`, then run `check 1401`.  
To experiment with the same test files the checker uses: `play 1401`.
