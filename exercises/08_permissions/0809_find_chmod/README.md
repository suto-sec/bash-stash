# 0809 · Fixing permissions in bulk

**Topic:** Permissions, chmod, umask, chown · **Difficulty:** ★★★☆☆ · **Commands:** find -perm, chmod

Security audit of the tree `compartido`:

1. print sorted the regular files that are **writable by others** (`-perm -o+w`)
2. remove write permission for others from all of them
3. remove **all** permissions for group and others from every file ending in `.key`

Print only the list from step 1.

---
Write your solution in `answer.sh`, then run `check 0809`.  
To experiment with the same test files the checker uses: `play 0809`.
