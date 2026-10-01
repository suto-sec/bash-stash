# 0738 · scriptcheck.sh: auditing shell scripts

**Topic:** find · **Difficulty:** ★★★★☆ · **Commands:** find -name '*.sh', head -n 1, test -x, chmod u+x, sed -i '1i'

Write `scriptcheck.sh`:

```
scriptcheck.sh [-f] DIR
```

For every **regular file** under `DIR` (recursively) whose name ends in `.sh`, in sorted path order,
it detects two problems:

- `no shebang`: the first line does not start with `#!` (exactly at the beginning of the line)
- `not executable`: the **user** (owner) execute permission is not set

For each file with problems print `<path>: <problems>` (path as `find` prints it), where problems is
`no shebang`, `not executable` or `no shebang, not executable`. Files without problems are not printed.

- Without `-f`: finally print `N scripts checked, M with problems`; exit **1** if M > 0, else 0.
- With `-f` (only allowed as the **first** argument): after printing each file's line, **fix** it:
  insert the line `#!/bin/bash` at the beginning if it had no shebang, and add the user execute
  permission (`chmod u+x`) if it wasn't executable. Finally print
  `N scripts checked, M with problems, M fixed` and exit 0.

Errors (stderr, wording free): missing `DIR`, too many arguments or an unknown option → usage,
exit **2**; `DIR` is not a directory → exit **3**. Names may contain spaces. No script is empty.
