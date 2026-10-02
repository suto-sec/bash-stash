# 2002 · Readable by everybody else

**Topic:** Exam tasks with the manual · **Difficulty:** ★★★☆☆ · **Commands:** find

The folder `publico` holds regular files (some in a subfolder) with all kinds of permissions.

Print the path of every file under `publico` that **others can read** (the `r` of the last group of permissions is set), whatever the other bits are. One per line, in alphabetical order.

Example: `rw-r--r--`, `rw-rw-r--` and `r--r--r--` match; `rw-r-----` and `rwx------` do not.

`find -perm` has three forms (`mode`, `-mode`, `/mode`) and they do very different things: choose the right one in `man find`.
