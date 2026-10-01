# 1716 · Running commands as another user

**Topic:** Users, groups, sessions, logs & cron · **Difficulty:** ★★☆☆☆ · **Commands:** sudo -u, su -c

Print:

1. the result of `whoami` run **as luke** (`sudo -u luke whoami`)
2. the primary group name of `sally`, obtained by running `id -gn` **as sally**
3. the home directory seen by a **login** shell of `rod`: `sudo -i -u rod pwd` (the `-i` loads the
   user's environment, like `su -`)
4. the result of `sudo whoami`
