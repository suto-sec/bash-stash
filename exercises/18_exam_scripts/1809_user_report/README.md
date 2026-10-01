# 1809 · Users report

**Topic:** Exam-style scripts · **Difficulty:** ★★★★☆ · **Commands:** while IFS=: read, grep -c, test -d

Write `usuarios.sh [passwd_file] [group_file]` (defaults `/etc/passwd`, `/etc/group`). For every user
with UID between 1000 and 59999 (in file order) print:

```
<login> uid=<uid> home=<home> (exists|missing) shell=<shell> groups=<N>
```

where `exists/missing` says whether the home directory exists **on this system**, and `groups` is the
number of lines of the group file whose member list (4th field, comma-separated) contains the login
**plus one** for the primary group. End with `Total: N users`.
If a file can't be read: stderr, exit 1.
