# 0123 · echo -e: escape sequences

**Topic:** Echo, quoting & substitution · **Difficulty:** ★☆☆☆☆ · **Commands:** echo -e

`echo -e` makes `echo` interpret escape sequences: `\n` is a new line and `\t` is a tab.

With **one single** `echo -e` command (one line of code), print these two lines. The second line has a TAB between `uno` and `dos` (shown here as a real tab character):

```
primera linea
uno	dos
```

Hint: `echo -e "first\nsecond\tthird"`
