# 0808 · What directory permissions mean

**Topic:** Permissions, chmod, umask, chown · **Difficulty:** ★★★☆☆ · **Commands:** chmod, ls, cd, test -r -w -x

The directory `caja` contains some files. Test what each directory permission allows. For each of the
three situations below, set the permission of `caja` **exactly** as stated with `chmod` and then print
three words: `ls:yes|no`, `cd:yes|no`, `create:yes|no`, each one meaning whether the operation worked:

- `ls caja >/dev/null 2>&1`
- `(cd caja) 2>/dev/null`
- `touch caja/nuevo 2>/dev/null` (remove `caja/nuevo` right after if it was created)

Situations: `chmod 700 caja`, `chmod 600 caja`, `chmod 300 caja`. Output example for the first:

```
700 ls:yes cd:yes create:yes
```

Finally, restore `caja` to `755`.
