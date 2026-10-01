# 0832 · Permissions live on the inode, not the name

**Topic:** Permissions, chmod, umask, chown · **Difficulty:** ★★★☆☆ · **Commands:** ln, chmod, stat -c '%a %n'

`a` and `b` are two names for the very same file (hard links: same inode), and `c` is a separate
file that merely has identical content. Predict, then verify:

1. `chmod 640 a`
2. print `stat -c '%a %n'` of `a`, `b` and `c`, in that order
3. `chmod 600 b`
4. print `stat -c '%a %n'` of `a`, `b` and `c` again

Because a permission mode belongs to the **inode**, changing it through any one of its hard-linked
names changes it for all of them — `c`, being a different inode, is never affected.
