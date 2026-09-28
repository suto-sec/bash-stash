# 0802 · chmod with octal numbers

**Topic:** Permissions, chmod, umask, chown · **Difficulty:** ★☆☆☆☆ · **Commands:** chmod 740

Using **octal** modes, set:

| file | permissions |
|------|-------------|
| `a` | `rwxr-----` |
| `b` | `rw-r--r--` |
| `c` | `rw-------` |
| `d` (a directory) | `rwxr-x--x` |
| `e` | `r--r--r--` |

---
Write your solution in `answer.sh`, then run `check 0802`.  
To experiment with the same test files the checker uses: `play 0802`.
