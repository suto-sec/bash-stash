# 0812 · umask calculator

**Topic:** Permissions, chmod, umask, chown · **Difficulty:** ★★★★☆ · **Commands:** $(( )), bitwise & ~

The script receives a umask in octal as its argument (e.g. `027`) and prints, for that umask,
the permissions a new **file** and a new **directory** would get, in octal (3 digits) and symbolic form:

```
file: 640 rw-r-----
dir: 750 rwxr-x---
```

Files start from `666`, directories from `777`, and the umask **removes** bits
(`$(( 8#666 & ~8#027 ))` gives the decimal value; print it back in octal with `printf '%03o'`).
You can obtain the symbolic form with a tiny helper or by really creating a temp file and dir.
