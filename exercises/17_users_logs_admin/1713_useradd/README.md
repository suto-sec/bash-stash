# 1713 · Creating a user (as root)

**Topic:** Users, groups, sessions, logs & cron · **Difficulty:** ★★★☆☆ · **Commands:** useradd -m -s -G -c, chpasswd, getent

This script is run **as root**. Create the user `pepe`:

- with home directory (`-m`), shell `/bin/bash`
- full name (GECOS) `Pepe Perez`
- supplementary group `devs`
- password `lab` (`echo 'pepe:lab' | chpasswd`)

Then print `getent passwd pepe` and `id -Gn pepe`.
(`adduser` is the interactive Debian wrapper; in scripts use `useradd`.)
