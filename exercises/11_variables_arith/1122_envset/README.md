# 1122 · envset.sh (exporting a config file)

**Topic:** Variables, arithmetic & environment · **Difficulty:** ★★★★☆ · **Commands:** export, parameter expansion, [[ =~ ]]

Write `envset.sh CONFIGFILE [PREFIX]`. `CONFIGFILE` has lines `KEY=VALUE` (`VALUE` may contain spaces
and even `=`). Blank lines and lines whose first non-blank character is `#` are comments: skip them
silently. Any other line that has no `=`, or whose `KEY` doesn't match `^[A-Za-z_][A-Za-z0-9_]*$`, is
invalid: print `Invalid line L: <line>` on stderr (L = 1-based line number) and skip it.

`export` every valid `KEY=VALUE` (later lines override earlier ones with the same `KEY`). If `PREFIX`
is given, only export keys that **start with** `PREFIX` (other valid keys are silently ignored, not
counted as invalid).

Finally print, sorted by key, `KEY=VALUE` for every exported variable, then `Exported N variables`.

- wrong number of arguments (not 1 or 2): usage on stderr, exit **1**
- `CONFIGFILE` not readable: stderr, exit **2**
- `PREFIX` given but not matching `^[A-Za-z_][A-Za-z0-9_]*$`: stderr, exit **3**
- if at least one invalid line was found, exit **4** at the end (only when there was no other error)

---
Write your solution in `answer.sh`, then run `check 1122`.  
To experiment with the same test files the checker uses: `play 1122`.
