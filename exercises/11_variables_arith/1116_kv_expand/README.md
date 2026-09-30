# 1116 · Splitting KEY=VALUE with parameter expansion

**Topic:** Variables, arithmetic & environment · **Difficulty:** ★★★☆☆ · **Commands:** ${v%%=*}, ${v#*=}, ${v,,}, ${v//}, ${#v}

The file `config.txt` contains one line `KEY=VALUE` (KEY is uppercase, VALUE is a `/`-separated path).
**Without** external commands (no `cut`, `sed`, `basename`...), only parameter expansion, print:

1. `KEY` (everything before the first `=`) — `${LINE%%=*}`
2. `VALUE` (everything after the first `=`) — `${LINE#*=}`
3. `KEY` in lowercase
4. `VALUE` with every `/` replaced by `_` — `${VALUE//\//_}`
5. the length of `VALUE`

---
Write your solution in `answer.sh`, then run `check 1116`.  
To experiment with the same test files the checker uses: `play 1116`.
