# 1427 · ip_classify.sh: what kind of IPv4 address?

**Topic:** test, if & case · **Difficulty:** ★★★★☆ · **Commands:** [[ =~ ]], case, test -ge -le, option -f, exit codes

Write `ip_classify.sh`:

```
ip_classify.sh ip...
ip_classify.sh -f file
```

The addresses come from the arguments or, with `-f` (only as the first argument), from the lines of
`file` (every line, as is, is one address; empty lines are skipped). For each address print
`<address>: <class>`, with the class given by the **first** matching rule:

| rule | class |
|------|-------|
| not a valid IPv4: 4 numbers 0-255 separated by dots, each `0` or digits not starting with `0` | `invalid` |
| first number 127 | `loopback` |
| `10.x.x.x`, `172.16.x.x`-`172.31.x.x`, `192.168.x.x` | `private` |
| `169.254.x.x` | `link-local` |
| first number 224-239 | `multicast` |
| first number 0 or 240-255 | `reserved` |
| anything else | `public` |

Finally print `N addresses: V valid, I invalid`.

Exit codes:

| situation | exit |
|-----------|------|
| no invalid address | 0 |
| some invalid address | 1 |
| no arguments, or `-f` not followed by exactly one file (usage on stderr) | 2 |
| the file is not a readable regular file (stderr, name it) | 3 |
