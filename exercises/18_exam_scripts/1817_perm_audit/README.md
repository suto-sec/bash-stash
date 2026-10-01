# 1817 · Permission audit

**Topic:** Exam-style scripts · **Difficulty:** ★★★★☆ · **Commands:** find -perm -o+w, -perm -1000, -perm /6000

Write `auditoria.sh [DIR]` (default: current directory) that prints four sections (each list sorted,
or `(none)`):

```
== world-writable files ==
== world-writable dirs without sticky bit ==
== setuid/setgid files ==
== scripts without execute permission ==
```

- world-writable files: regular files writable by others
- world-writable dirs without sticky bit: directories writable by others and without `t` (`! -perm -1000`)
- setuid/setgid: regular files with the SUID or SGID bit (`-perm /6000`)
- scripts without execute: regular `*.sh` files with **no** execute bit at all

Exit code: 0 if all sections are empty, 1 otherwise. Not a directory: stderr, exit 2.
