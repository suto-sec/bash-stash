# 0829 · A symlink's permissions are not its own

**Topic:** Permissions, chmod, umask, chown · **Difficulty:** ★★★☆☆ · **Commands:** stat -c %a, test -L -e, readlink, ln -s

The directory `enlaces` contains regular files and symbolic links to them (some links are
**broken**). A symbolic link's own mode is meaningless for access control (it is always shown as
`rwxrwxrwx`); what matters is the permissions of whatever it points to — and `stat -c %a` on a link
already reports the **target's** mode automatically, not the link's own.

For every entry directly inside `enlaces`, in the order of the `enlaces/*` glob:

- if it is a broken symbolic link, print `NAME: broken`
- if it is a symbolic link to something that exists, print `NAME -> TARGET: MODE`, where `TARGET` is
  its stored target (`readlink`) and `MODE` is the octal mode of what it resolves to (`stat -c %a`)
- otherwise (a regular file, not a link), print `NAME: MODE`

---
Write your solution in `answer.sh`, then run `check 0829`.  
To experiment with the same test files the checker uses: `play 0829`.
