# 1504 · Splitting fields with IFS

**Topic:** Loops: for, while, until, read · **Difficulty:** ★★☆☆☆ · **Commands:** while IFS=: read -r a b c

Read the `passwd` file (in the current directory) with a `while IFS=: read -r ...` loop and print,
for every user with UID ≥ 1000, `user (uid) -> shell`.
