# 0343 · ln -s: a symbolic link

**Topic:** Files, copies & links · **Difficulty:** ★☆☆☆☆ · **Commands:** ln -s, readlink

A symbolic link is a small file that stores the path of another file (like a shortcut).

The current directory contains the file `original`.

1. Create a symbolic link called `blando` that points to `original`.
2. Print the path stored inside `blando` with `readlink`.

Expected output:

```
original
```

Hint: `ln -s TARGET LINKNAME`, then `readlink LINKNAME`.
