# 1727 · A user's groups from the files

**Topic:** Users, groups, sessions, logs & cron · **Difficulty:** ★★★☆☆ · **Commands:** grep, cut, IFS=: read, tr

Write `usergroups.sh USER [passwd_file] [group_file]` (defaults `/etc/passwd`, `/etc/group`) that
works out the groups of `USER` **from the files** (not with `id`), and prints:

```
primary: <group>
supplementary: <g1> <g2> ...
total: <N>
```

- primary: the name of the group whose GID (3rd field of the group file) is the 4th field of the user's
  passwd line; if no group has that GID, print the number instead
- supplementary: the groups (in group-file order, separated by one space) whose member list (4th
  field, comma-separated) contains exactly `USER`, **excluding** the primary group; `(none)` if there
  are none. Careful: `luke` is not a member of a group whose list is `lukes,sally`.
- total: 1 + number of supplementary groups

Errors (message on stderr):

- no arguments or more than 3: usage, exit **2**
- a file cannot be read: exit **3**
- `USER` has no line in the passwd file: message naming the user, exit **1**
