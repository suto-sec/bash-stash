# 1420 · Parsing dated backup names with BASH_REMATCH

**Topic:** test, if & case · **Difficulty:** ★★★☆☆ · **Commands:** [[ =~ ]], BASH_REMATCH, test -ge -le

Backups are named `NAME_YYYY-MM-DD.tar.gz` or `NAME_YYYY-MM-DD.tgz`, where NAME is one or more
letters, digits or `-` (no `_`, no spaces). For each argument print

- `<NAME>: DD/MM/YYYY (<ext>)` if it is valid (`<ext>` is `tar.gz` or `tgz`), e.g.
  `web_2024-08-09.tgz` → `web: 09/08/2024 (tgz)`
- `invalid: <argument>` otherwise

Valid also requires month `01`-`12` and day `01`-`31` (do not check days per month). Careful with
`08` and `09`: they are not valid numbers **inside `$(( ))`** (octal!), but `[ 08 -le 12 ]` works.

At the end print `V valid, I invalid`. Use one `=~` with groups and `BASH_REMATCH`.
