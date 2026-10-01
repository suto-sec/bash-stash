# 1332 · Rotating the positional parameters

**Topic:** Script parameters & exit codes · **Difficulty:** ★★★☆☆ · **Commands:** set --, shift, $(( % )), "$@"

The first argument is an integer K (may be `0` or larger than the number of remaining arguments); the
rest are a list of items. Rotate the list **left** by K positions, cyclically (K is taken modulo the
list length), and print the result **one item per line**. Do it with `shift` (to drop items off the
front) and `set --` (to re-append them at the end) — do not use arrays.

If there are no items after the first argument, print `Error: no hay elementos` on stderr and exit 1.
If K is not a non-negative integer, print `Error: K invalido` on stderr and exit 2 (checked only once
there is at least one item).
