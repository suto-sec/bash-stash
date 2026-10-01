# 1015 · Commands without man page

**Topic:** Pipes, xargs & command substitution · **Difficulty:** ★★★★☆ · **Commands:** ls, comm, sed, sort

Print, sorted, the names of the files in `/bin` whose name starts with `z` and that do **not** have a
man page in section 1 (`/usr/share/man/man1/NAME.1.gz`). Solve it with a pipeline:
`comm -23` between the sorted list of names in `/bin` and the sorted list of man1 page names
(strip `.1.gz` with `sed`).
