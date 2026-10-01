# 1622 · primos.sh: recursive primality testing

**Topic:** Functions · **Difficulty:** ★★★★☆ · **Commands:** recursion, return, [[ =~ ]], exit codes

Write `primos.sh N...`. Write a **recursive** function `es_primo N [D]` (D defaults to 2) that
**returns** 0 if N is prime and 1 otherwise: if `D*D > N` return 0 (prime); if `N % D == 0` return
1 (not prime); otherwise recurse with `D+1`.

For each argument that is a valid integer `>= 2`, print `N: primo` or `N: no primo`. An argument
that is **not** a valid integer `>= 2` is not fatal: print a message on stderr naming it (wording
free) and skip it.

At the end print `TOTAL: P primos de V validos`.

Exit codes: 0 on success; 1 if there are no arguments at all (usage on stderr); 2 if there is at
least one argument but **none** of them is valid (checked after processing all arguments).
