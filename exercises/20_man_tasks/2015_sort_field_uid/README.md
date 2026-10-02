# 2015 · Users by UID, highest first

**Topic:** Man page tasks · **Difficulty:** ★★★☆☆ · **Commands:** sort, cut

`cuentas.txt` has lines like the ones in `/etc/passwd`: fields separated by `:`, where the 3rd field is the numeric UID.

Print only the **user names** (1st field), ordered by **UID from the highest to the lowest**.

Example: for `ana:x:1001:...` and `luis:x:1500:...` the output is `luis`, then `ana`.

Sorting by a field with another separator and numerically, in reverse, is all in `man sort`.
