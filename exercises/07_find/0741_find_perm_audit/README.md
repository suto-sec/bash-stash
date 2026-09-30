# 0741 · Combining -perm forms: /mode, -mode and !

**Topic:** find · **Difficulty:** ★★★☆☆ · **Commands:** find -perm /mode, -perm -mode, !

Under `sistema`, print sorted, separated by `---`:

1. regular files where **at least one** of group or other has **write** permission
   (`-perm /022`) — a classic "world/group writable" security check.
2. regular files where the **owner has full `rwx`** *and* **neither group nor other has any
   permission at all** (`-perm -700 ! -perm /077`).
3. regular files that have the **setuid bit** set **and** are **executable by the owner**
   (`-perm -4100`). Beware: a file can have the setuid bit without being owner-executable —
   that must **not** match.

---
Write your solution in `answer.sh`, then run `check 0741`.  
To experiment with the same test files the checker uses: `play 0741`.
