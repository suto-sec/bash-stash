# 0317 · Backups that keep their dates

**Topic:** Files, copies & links · **Difficulty:** ★★★☆☆ · **Commands:** cp -p, mv, test -e, touch -d

The current directory contains several `*.conf` files (and other files). For every file `X.conf`
directly in the current directory:

1. if `X.conf.bak` already exists, rename it to `X.conf.bak.old` (replacing any previous `.old`)
2. copy `X.conf` to `X.conf.bak` **preserving** its permissions and modification time (`man cp`)

Nothing is printed. The checker compares permissions, contents and modification times of every file.

---
Write your solution in `answer.sh`, then run `check 0317`.  
To experiment with the same test files the checker uses: `play 0317`.
