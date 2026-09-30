# 1417 · case: what kind of argument is it?

**Topic:** test, if & case · **Difficulty:** ★★★☆☆ · **Commands:** case, glob patterns [ ] [! ] * ?

For each argument print `'<arg>': <kind>` (the argument between single quotes), where `<kind>` is
given by the **first** matching row:

| argument | kind |
|----------|------|
| empty (`""`) | `empty` |
| exactly `--` | `end of options` |
| starts with `--` | `long option` |
| `-` followed by exactly one letter (a-z, A-Z) | `short option` |
| only digits (at least one) | `number` |
| starts with `.` | `hidden` |
| contains `/` | `path` |
| ends in `.sh` | `script` |
| anything else | `word` |

Use `case` (hint: "only digits" is "does not match `*[!0-9]*`"). Careful with arguments like `*`.

---
Write your solution in `answer.sh`, then run `check 1417`.  
To experiment with the same test files the checker uses: `play 1417`.
