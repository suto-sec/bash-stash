# 1532 · miembros.sh: nested loops over a group file

**Topic:** Loops: for, while, until, read · **Difficulty:** ★★★★☆ · **Commands:** while IFS=: read -r, IFS=, read -ra, nested for, [[ =~ ]]

Write `miembros.sh GROUPFILE USER...`. GROUPFILE has the format of `/etc/group`:
`name:x:gid:member1,member2,...` (the member list may be empty). For each USER, in argument order,
print

```
USER: g1 g2 ...
```

with the names of the groups whose **member list** contains exactly USER, in file order, separated
by one space, or `USER: -` if none. (Only the member list counts, not the group name, and `ana` is
not a member of a group that lists `anabel`.)

A USER that is not a valid user name (`^[a-z_][a-z0-9_-]*$`) prints `invalid user name: USER` on
**stderr** and is skipped. Finally print `N users checked, M without groups` (valid users only).

Exit codes: fewer than 2 arguments → **1** (usage on stderr); GROUPFILE not a readable regular file →
**2** (stderr, name it); otherwise **3** if some user name was invalid, else 0.
