# 1529 · lineas.sh: printing a range of lines

**Topic:** Loops: for, while, until, read · **Difficulty:** ★★★★☆ · **Commands:** while IFS= read -r, break, [[ =~ ]], exit codes

Write `lineas.sh FILE FROM TO` that prints lines FROM to TO (both included, the first line is 1) of
FILE, each as `N: text` (the text exactly as in the file: leading spaces, tabs and backslashes
included), using a `while read` loop that **stops reading** (`break`) once line TO is printed.
The last line of the file may not end with a newline; it still counts. If the file has fewer lines,
print what exists. Finally print `printed K lines`.

Errors (message on **stderr**, wording free, checked in this order):

| situation | exit |
|-----------|------|
| not exactly 3 arguments (show the usage) | 1 |
| FILE is not a readable regular file (name it) | 2 |
| FROM or TO is not a positive integer (digits only, ≥ 1) (name the bad value) | 3 |
| FROM > TO | 4 |

---
Write your solution in `answer.sh`, then run `check 1529`.  
To experiment with the same test files the checker uses: `play 1529`.
