# 0618 · Patterns that start with a dash

**Topic:** grep & regular expressions · **Difficulty:** ★★★☆☆ · **Commands:** grep -e, grep --, grep -c -v

`cmds.txt` contains one shell command line per line. A pattern that starts with `-` is taken by
`grep` as an option unless you protect it with `-e PATTERN` or `--`. Print, separated by `---`:

1. the lines that contain `-rf`
2. the lines that contain `-n` **or** `--dry-run` (a single `grep` with two `-e`)
3. the **number** of lines that contain no `-` at all

---
Write your solution in `answer.sh`, then run `check 0618`.  
To experiment with the same test files the checker uses: `play 0618`.
