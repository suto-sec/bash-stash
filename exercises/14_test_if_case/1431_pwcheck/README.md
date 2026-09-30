# 1431 · pwcheck.sh: password strength

**Topic:** test, if & case · **Difficulty:** ★★★★☆ · **Commands:** [[ =~ ]], [[:lower:]] [[:upper:]] [[:digit:]], ${#var}, ${1:-8}, exit codes

Write `pwcheck.sh [minlen]`. It reads candidate passwords from **standard input**, one per line
(empty lines are skipped; a line is used exactly as it is), and prints one line per password:

- `<pw>: rejected (spaces)` if it contains a space
- `<pw>: rejected (too short)` if it has fewer than `minlen` characters (default **8**)
- otherwise `<pw>: <label> (<score>/4)`, where score is how many of these classes it contains:
  lowercase letter, uppercase letter, digit, symbol (any other character); label is `strong` for
  4, `medium` for 3 and `weak` for 0-2

(Use the classes `[[:lower:]]`, `[[:upper:]]`, `[[:digit:]]`, `[^[:alnum:]]`.) Finally print
`strong S, medium M, weak W, rejected R`.

Exit codes:

| situation | exit |
|-----------|------|
| every password strong or medium (also when there are none) | 0 |
| some password weak or rejected | 1 |
| more than one argument (usage on stderr) | 2 |
| `minlen` is not an integer from 4 to 64 (digits, not starting with 0) (stderr, name it) | 3 |

---
Write your solution in `answer.sh`, then run `check 1431`.  
To experiment with the same test files the checker uses: `play 1431`.
