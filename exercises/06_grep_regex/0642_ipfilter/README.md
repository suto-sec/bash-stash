# 0642 · ipfilter.sh: filtering by an IP prefix (the escaping trap)

**Topic:** grep & regular expressions · **Difficulty:** ★★★★☆ · **Commands:** grep -E, sed (escaping dots), [[ =~ ]], script argument

Write `ipfilter.sh`:

```
ipfilter.sh FILE PREFIX
```

`PREFIX` looks like the start of a dotted IPv4 address (`192.`, `192.168.`, `192.168.1.`...).
Print the lines of `FILE` that contain an IPv4-looking address starting with exactly `PREFIX`
followed by at least one more digit.

This is a classic trap: `PREFIX`'s dots are **literal dots**, not "any character" — if you build the
`grep` pattern from `PREFIX` without escaping them first, `192.168.1.` would also match text like
`192x168x1x9`, and (worse) `192.168.1.` would wrongly match inside `192.168.10.5` unless the dot
right after the prefix is required to be literal too. Escape every `.` in `PREFIX` (e.g. with `sed
's/\./\\./g'`) before using it inside the pattern.

Errors (message on **stderr**, nothing on stdout):

- not exactly 2 arguments: error and usage, exit **1**
- `FILE` is not a readable regular file: message with its name, exit **2**
- `PREFIX` doesn't look like the start of an IPv4 address (only digits and dots, 1 to 3 groups,
  optionally ending in a dot): message with it, exit **3**

---
Write your solution in `answer.sh`, then run `check 0642`.  
To experiment with the same test files the checker uses: `play 0642`.
