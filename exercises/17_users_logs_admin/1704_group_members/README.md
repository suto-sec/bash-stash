# 1704 · Who belongs to a group

**Topic:** Users, groups, sessions, logs & cron · **Difficulty:** ★★★☆☆ · **Commands:** /etc/group, /etc/passwd, cut, tr

The script receives a group name. Print, sorted and without duplicates, **all** the users that belong
to it: those listed as members in `/etc/group` (4th field, comma-separated) **plus** those whose
**primary** group (4th field of `/etc/passwd`) is that group's GID.

If the group does not exist, print `no such group: NAME` on stderr and exit 1.
