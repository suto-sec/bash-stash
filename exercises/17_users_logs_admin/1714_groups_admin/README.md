# 1714 · Creating groups and adding members (as root)

**Topic:** Users, groups, sessions, logs & cron · **Difficulty:** ★★★☆☆ · **Commands:** groupadd, usermod -aG, gpasswd -d, getent group

Run **as root**:

1. create the group `auditores`
2. add `luke` and `sally` to it **without removing** their other groups (`usermod -aG`)
3. remove `sally` from it again (`gpasswd -d`)
4. print `getent group auditores` and `id -Gn luke`
