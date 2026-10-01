# 0803 · Reading permissions

**Topic:** Permissions, chmod, umask, chown · **Difficulty:** ★★☆☆☆ · **Commands:** stat -c %a %A, ls -l

For every entry of the directory `varios` (sorted by name) print a line
`name symbolic octal`, e.g. `notas.txt -rw-r----- 640`.

Hint: `stat -c '%n %A %a'` gives this almost directly (but `%n` includes the path you pass: `cd` first).
