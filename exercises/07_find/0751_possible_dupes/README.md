# 0751 · possible_dupes.sh: files that might be duplicates

**Topic:** find · **Difficulty:** ★★★★☆ · **Commands:** find -printf, sort -n, uniq -c, grep -v, script argument

Write `possible_dupes.sh`:

```
possible_dupes.sh [directory]
```

Under `directory` (default: the current directory), regular files that share the **exact same
size** (in bytes) as at least one other regular file are potential duplicates. Using
`find ... -printf '%s\n' | sort -n | uniq -c`, print only the size groups with **more than one**
file, in the same format `uniq -c` produces (count then size), ordered by size ascending. Then
print exactly:

```
Total: N grupos
```

where `N` is the number of such groups (not the number of files).
