# 1712 · /etc/shadow (with sudo)

**Topic:** Users, groups, sessions, logs & cron · **Difficulty:** ★★★☆☆ · **Commands:** sudo, /etc/shadow, cut, grep

`/etc/shadow` is only readable by root, but you can use `sudo` (password `lab`; in the lab it won't ask).
Print:

1. the exit code of trying to `cat /etc/shadow` **without** sudo (hide the error)
2. the users whose real password is **locked**: the password field is `!` followed by a hash
   (`!$...`), sorted. (System accounts have `*` or `!*`: no password at all, not "locked".)
3. the users that have a real password hash (field starts with `$`), sorted
