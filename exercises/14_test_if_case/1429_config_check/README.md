# 1429 · config_check.sh: validating a configuration file

**Topic:** test, if & case · **Difficulty:** ★★★★☆ · **Commands:** [[ =~ ]], BASH_REMATCH, case, test -d, exit codes

Write `config_check.sh file`, which validates a `key=value` configuration file. Process the lines in
order (numbered counting **all** lines); blank lines and lines starting with `#` are ignored. For
each other line, report the **first** problem of this list (if any), all on stdout:

1. the line is not `key=value` with `key` made only of lowercase letters and `_` (at least one) and
   `value` anything (possibly empty): `line N: syntax error`
2. the key already appeared on an earlier line without a syntax error: `line N: duplicate key 'key'`
3. the key is not one of the known keys below: `line N: unknown key 'key'`
4. the value is not valid for that key: `line N: bad value for key: 'value'`

| key | valid values |
|-----|--------------|
| `port` | integer 1-65535 (digits, not starting with 0) |
| `mode` | `on` or `off` |
| `name` | non-empty, without spaces |
| `logdir` | an existing directory (relative to the current directory) |
| `level` | `debug`, `info`, `warn` or `error` |

After the last line, for each of the **required** keys `name` and `port` (in that order) that never
appeared (without syntax error) print `missing key: <key>`. Finally print `OK` if there were no
problems, or `P problems` (P = number of problem lines printed).

Exit codes: **0** no problems, **1** some problem, **2** not exactly one argument (usage on stderr),
**3** `file` is not a readable regular file (stderr, name it).

---
Write your solution in `answer.sh`, then run `check 1429`.  
To experiment with the same test files the checker uses: `play 1429`.
