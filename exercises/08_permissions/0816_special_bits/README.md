# 0816 · setuid, setgid and sticky

**Topic:** Permissions, chmod, umask, chown · **Difficulty:** ★★★☆☆ · **Commands:** chmod u+s g+s +t, 4755, find -perm /6000

Set these **exact** modes (the entries exist, with other permissions):

| entry | wanted |
|-------|--------|
| `tmpcomun` (directory) | `rwxrwxrwt` (everyone writes, sticky bit: only the owner of a file can delete it) |
| `herramienta` (file) | `rwsr-xr-x` (setuid) |
| `compartido` (directory) | `rwxrws---` (setgid: new files inherit the directory's group) |
| `raro` (file) | `rwSr--r--` (setuid **without** execute: capital `S`) |

Then print `stat -c '%A %a %n'` of `tmpcomun herramienta compartido raro` (in that order), a line
`---`, and the sorted list of entries under the current directory (`find .`, any depth) that have the
setuid **or** setgid bit.

---
Write your solution in `answer.sh`, then run `check 0816`.  
To experiment with the same test files the checker uses: `play 0816`.
