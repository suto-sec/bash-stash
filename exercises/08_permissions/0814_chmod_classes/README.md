# 0814 · Copying permissions between classes

**Topic:** Permissions, chmod, umask, chown · **Difficulty:** ★★★☆☆ · **Commands:** chmod g=u, o=g, o-w

For every entry directly inside `equipo` (files and directories; names may contain spaces):

1. the **group** must get exactly the same permissions as the **user** (owner)
2. then **others** must get exactly the group's permissions **without write**

The user's permissions do not change. Then print `stat -c '%a %n'` of every entry of `equipo`, in the
order of the `equipo/*` glob.

Hint: `chmod` accepts `u`, `g` or `o` on the right side of `=` (`man chmod`): `chmod g=u f` copies the
user's permissions to the group. Clauses separated by commas are applied in order.
