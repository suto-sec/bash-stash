# 0324 · trash.sh (a recycle bin)

**Topic:** Files, copies & links · **Difficulty:** ★★★★☆ · **Commands:** mv, mkdir, basename, test -e -d, while (name collisions), exit codes

Write `trash.sh`, a safe replacement for `rm`:

```
trash.sh FILE...
```

It **moves** every FILE into the trash directory `$HOME/.papelera`.

- If `$HOME/.papelera` does not exist, create it and print `Created <full path of the trash>`
  (only when at least one file is going to be processed, i.e. after checking there are arguments).
- The name inside the trash is the basename of FILE. If that name is already taken in the trash, use
  `NAME.1`, or `NAME.2` if `NAME.1` is also taken, and so on (the first free number).
- For every file moved print `trashed <FILE> as <name in trash>` (FILE exactly as given).
- An argument that does not exist: error message on stderr **including its name**; continue with the
  rest.
- An argument that is a directory: error message on stderr **including its name**, it is not moved;
  continue with the rest.
- At the end print `N trashed, M errors`.

Exit codes: **1** if there are no arguments (usage message on stderr, nothing else happens); **2** if at
least one argument produced an error; **0** otherwise. Arguments are processed in the order given and
may contain spaces.
