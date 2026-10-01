# 0811 · Permission calculator

**Topic:** Permissions, chmod, umask, chown · **Difficulty:** ★★★★☆ · **Commands:** variables, $(( )), string slicing / case

The script receives a symbolic permission string of 9 characters as its **first argument**
(e.g. `rwxr-x---`) and prints its octal value (`750`).

Validate the argument: if it is missing or not 9 characters made of `r`, `w`, `x`, `-` in the
right positions, print an error to **stderr** and exit with code **1**.
