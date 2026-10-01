# 1718 · Writing sudoers rules

**Topic:** Users, groups, sessions, logs & cron · **Difficulty:** ★★★★☆ · **Commands:** /etc/sudoers syntax, visudo -c

Write (into the file `lab_sudoers` in the current directory) sudoers rules so that:

1. members of the group `devs` can run `/usr/bin/systemctl restart cups` as root **without** password
2. user `luke` can run `/bin/kill` as root **with** password and `/bin/ls` **without** password
   (like the classic `ray rushmore` sudoers example, but for `ALL` hosts)
3. user `jgarcia` can run **any** command as **any** user

Then validate it with `visudo -c -f lab_sudoers` (it prints `lab_sudoers: parsed OK`).
The checker validates the syntax with `visudo` and then checks each of the three rules.
