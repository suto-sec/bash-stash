# 0616 · Real files: /etc/passwd and /etc/group

**Topic:** grep & regular expressions · **Difficulty:** ★★★☆☆ · **Commands:** grep, cut, sort

Using the **real** system files, print separated by `---`:

1. the login names (sorted) of the users of `/etc/passwd` whose shell is exactly `/bin/bash`
2. the login names (sorted) of users whose login name starts with `r`
3. the names of the groups of `/etc/group` that have **at least one** member listed (4th field not empty), sorted

---
Write your solution in `answer.sh`, then run `check 0616`.  
To experiment with the same test files the checker uses: `play 0616`.
