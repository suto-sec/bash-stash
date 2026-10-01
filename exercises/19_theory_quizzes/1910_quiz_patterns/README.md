# 1910 · Globs vs regular expressions

**Topic:** Theory quizzes · **Difficulty:** ★★★☆☆ · **Commands:** *, ?, [ ], grep, find

Answer in `answer.txt` as `N: answer` (yes/no unless stated).

1. Does the glob `*.txt` match the file `.oculto.txt`?
2. Does the glob `?.log` match `ab.log`?
3. Does the glob `[!a]*` match `abc`?
4. Does the regex `^c..h$` match the line `catch`?
5. Does the regex `b[^ae]g` match the line `big`?
6. Does the ERE `colou?r` match the whole line `colouur` with `grep -xE`?
7. Does the ERE `x+y` match the line `y`?
8. Is `+` a special (repetition) character in `grep` **without** `-E`?
9. Does `grep -w log` match the line `syslog started`?
10. Does `find . -name 'a*'` also list **directories** whose name starts with `a`?
11. Does `find -size -1M` match a file of 500 bytes? (think about rounding up to units)
12. Does `find -mtime +7` match a file modified 7.5 days ago?
13. Which `grep` option is needed for `[0-9]{1,3}` to be a repetition? (option)
14. Does `ls *` show hidden files?
15. In the regex `.*`, what does `.` mean? a) a literal dot b) any single character (a/b)
