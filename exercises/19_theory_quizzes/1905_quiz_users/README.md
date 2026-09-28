# 1905 · Users, groups & sudo

**Topic:** Theory quizzes · **Difficulty:** ★★☆☆☆ · **Commands:** /etc/passwd, /etc/shadow, /etc/group, su, sudo, passwd

Answer in `answer.txt` as `N: answer`.

1. UID of `root`. (number)
2. Home directory of `root`. (path)
3. Field number of the **login shell** in `/etc/passwd`. (number)
4. Field number of the **home directory** in `/etc/passwd`. (number)
5. File that stores the (hashed) passwords. (path)
6. File that stores the groups and their members. (path)
7. GID of the `root` group. (number)
8. Option of `passwd` that **locks** an account. (option)
9. Option of `passwd` that forces a password change at next login. (option)
10. Option of `su` that loads the target user's full environment (login shell). (option; `-` counts)
11. Option of `su` to run a single command. (option)
12. File that configures `sudo`. (path)
13. Command that safely edits (and validates) that file. (command)
14. What do you get with `sudo -s`? a) the sudoers file b) a root shell c) the status of sudo (a/b/c)
15. Command that lists the groups of a user given its name. (command)
16. Command that shows the login history (reads `wtmp`). (command)
17. In sudoers, what does the prefix `%` in `%admin ALL=(ALL) ALL` mean? a) a comment b) a group
    c) a host alias (a/b/c)
18. Command to add an **existing** user `u` to the supplementary group `g` without removing its other
    groups (with `usermod`). (command)

---
Write your answers in `answer.txt` (one `N: answer` line per question), then run `check 1905`.
