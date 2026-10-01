# 1308 · Capturing $? of commands

**Topic:** Script parameters & exit codes · **Difficulty:** ★★☆☆☆ · **Commands:** $?, grep, ls, test

Print the exit code of each of these commands (hide their normal and error output):

1. `ls /`
2. `ls /noexiste`
3. `grep root /etc/passwd`
4. `grep zzzz /etc/passwd`
5. `test 3 -gt 5`
6. `true` and then `false` (two lines)

Then run `mkdir existe` twice and print both exit codes, as `first=X second=Y`.
