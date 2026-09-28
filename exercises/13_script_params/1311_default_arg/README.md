# 1311 · Optional arguments with defaults

**Topic:** Script parameters & exit codes · **Difficulty:** ★★☆☆☆ · **Commands:** ${1:-default}

The script (`listar.sh [dir] [n]`) prints the first `n` entries (plain `ls`, sorted) of directory `dir`.
Defaults: `dir` = current directory, `n` = 3. Use `${1:-.}` and `${2:-3}`.

---
Write your solution in `answer.sh`, then run `check 1311`.  
To experiment with the same test files the checker uses: `play 1311`.
