# 1715 · Locking accounts (as root)

**Topic:** Users, groups, sessions, logs & cron · **Difficulty:** ★★★☆☆ · **Commands:** passwd -l, passwd -u, passwd -S, passwd -e

Run **as root**:

1. lock the account `rmartin` (`passwd -l`) and print the **second** field of `passwd -S rmartin`
   (`L` = locked, `P` = usable password)
2. unlock it and print the field again
3. force `rmartin` to change the password at next login (`passwd -e`) and print the **third**
   field of `passwd -S rmartin` (the date of the last change: `01/01/1970` means "must change")

---
Write your solution in `answer.sh`, then run `check 1715`.  
To experiment with the same test files the checker uses: `play 1715`.
