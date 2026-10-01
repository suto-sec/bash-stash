# 0706 · Searching by permissions

**Topic:** find · **Difficulty:** ★★★☆☆ · **Commands:** find -perm -mode, -perm /mode

Under `bin`, print sorted, separated by `---`:

1. regular files with **exactly** permissions `755`
2. regular files where **someone** (user, group or others) has **execute** permission (`-perm /111`)
3. regular files that have **all** of `u+w` and `g+w` (`-perm -220`)
4. regular files **without any** execute permission
