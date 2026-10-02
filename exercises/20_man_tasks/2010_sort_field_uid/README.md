# 2010 · Users by UID

**Topic:** Exam tasks with the manual · **Difficulty:** ★★★☆☆ · **Commands:** sort, cut

`cuentas.txt` has lines like the ones in `/etc/passwd`: fields separated by `:`, where the 3rd field is the numeric UID.

Print only the **user names** (1st field), ordered by **UID from the lowest to the highest**.

Example: for `luis:x:1500:...` and `ana:x:1001:...` the output is `ana`, then `luis`.

Sorting by a field with another separator, and numerically, is all in `man sort` (`-t`, `-k`, `-n`).
