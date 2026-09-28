# 1713 · Creating a user (as root)

**Topic:** Users, groups, sessions, logs & cron · **Difficulty:** ★★★☆☆ · **Commands:** useradd -m -s -G -c, chpasswd, getent

This script is run **as root**. Create the user `pepe`:

- with home directory (`-m`), shell `/bin/bash`
- full name (GECOS) `Pepe Perez`
- supplementary group `devs`
- password `lab` (`echo 'pepe:lab' | chpasswd`)

Then print `getent passwd pepe` and `id -Gn pepe`.
(`adduser` is the interactive Debian wrapper; in scripts use `useradd`.)

---
Write your solution in `answer.sh`, then run `check 1713`.  
To experiment with the same test files the checker uses: `play 1713`.
