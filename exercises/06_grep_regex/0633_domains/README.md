# 0633 · domains.sh (e-mail addresses per domain)

**Topic:** grep & regular expressions · **Difficulty:** ★★★★☆ · **Commands:** grep -o -h -E, tr, sort -u, uniq -c, cut

Write `domains.sh`:

```
domains.sh FILE...
```

It extracts the e-mail addresses that appear anywhere in the given files. An address is:
one or more letters, digits, `.`, `_`, `+` or `-`; then `@`; then one or more **labels** (letters,
digits, `-`) each followed by `.`; then 2 or more letters (take the longest match, as `grep -oE` does).
Addresses are compared **in lowercase** (`Ana@Example.COM` = `ana@example.com`).

Print, for every domain (the part after `@`, lowercase), the number of **distinct** addresses of that
domain, as `<domain> <count>`, sorted by count descending and then by domain ascending (as `sort`
orders them). Finally print `<A> distinct addresses, <D> domains`.

- No arguments: usage on stderr, exit **1**.
- A `FILE` that is not a readable regular file: message on stderr naming it, skip it and go on;
  at the end exit **2**.
- Otherwise, if no address was found at all: exit **3** (the summary `0 distinct addresses, 0 domains`
  is still printed). Else exit 0.
