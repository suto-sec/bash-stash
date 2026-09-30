# 0824 · effective.sh (what can this user do?)

**Topic:** Permissions, chmod, umask, chown · **Difficulty:** ★★★★☆ · **Commands:** id -Gn, stat -c %U %G %A, ${s:i:n}, exit codes

Write:

```
effective.sh USER FILE...
```

For every FILE, print which permissions `USER` gets on it according to the classic Unix rule, which
picks **one** class only:

1. if `USER` is the **owner** of the file → the owner's permissions (even if group or others have more!)
2. else, if `USER` belongs to the file's **group** (primary or supplementary: `id -Gn USER`) → the
   group's permissions
3. else → the permissions of **others**

Output one line per file: `FILE: rwx (class)` where `rwx` are the 3 characters of that class as
`ls -l` shows them (e.g. `r-x`) and `class` is `owner`, `group` or `other`. The files have no special
bits (setuid, setgid, sticky). Finally print `N files checked` (only existing files count).

Errors (message on stderr):

- fewer than 2 arguments → usage, exit **1**
- `USER` does not exist → exit **2**, message including the name
- `USER` is `root` (uid 0 bypasses permissions) → exit **3**
- a FILE that does not exist → message including its name, skip it and continue; at the end exit **4**
  (otherwise exit **0**)

---
Write your solution in `answer.sh`, then run `check 0824`.  
To experiment with the same test files the checker uses: `play 0824`.
