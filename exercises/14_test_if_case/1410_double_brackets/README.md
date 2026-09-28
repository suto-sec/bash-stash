# 1410 · [[ ]]: patterns and regex

**Topic:** test, if & case · **Difficulty:** ★★★☆☆ · **Commands:** [[ == pattern ]], [[ =~ ]], BASH_REMATCH

For each argument print one line:

- `email user=<u> domain=<d>` if it looks like an email `user@domain.tld` (use `=~` with groups and
  `BASH_REMATCH`; user and domain are sequences of letters, digits, `.`, `_` or `-`; tld is 2-6 letters)
- `backup` if it matches the **glob** pattern `*.bak` or `*~` (`[[ $x == *.bak ]]`)
- `other` otherwise

---
Write your solution in `answer.sh`, then run `check 1410`.  
To experiment with the same test files the checker uses: `play 1410`.
