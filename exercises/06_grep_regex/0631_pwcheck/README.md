# 0631 · pwcheck.sh (checking a passwd file)

**Topic:** grep & regular expressions · **Difficulty:** ★★★★☆ · **Commands:** grep -n -v -E, cut, sort, uniq -c, >&2

Write `pwcheck.sh`:

```
pwcheck.sh FILE
```

`FILE` has the format of `/etc/passwd`. Empty lines and lines starting with `#` are ignored.
Any other line is **well-formed** when it has exactly 7 fields separated by `:`, where

- the login (field 1) is a lowercase letter or `_` followed by lowercase letters, digits, `_` or `-`
- UID and GID (fields 3 and 4) are one or more digits
- the shell (field 7) is not empty (the other fields may be empty)

1. For every line that is not well-formed, print on **stderr** exactly `line <N>: <the line>`
   (`N` = line number in the file), in file order.
2. On **stdout**, for the well-formed lines, print how many users use each shell, as
   `<count> <shell>` (no leading spaces), count descending and then shell ascending (as `sort` orders them).
3. Finally print on stdout `<U> users, <M> malformed` (`U` = well-formed lines).

Exit code: 0 if there are no malformed lines, **4** otherwise.
Errors: not exactly one argument → usage on stderr, exit **1**; `FILE` not a readable regular
file → stderr, exit **2**.
