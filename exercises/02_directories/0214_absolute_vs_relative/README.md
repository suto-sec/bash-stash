# 0214 · Absolute and relative paths

**Topic:** Directories & navigation · **Difficulty:** ★★★☆☆ · **Commands:** cd, pwd, realpath

The file `where.txt` contains a **relative** path to an existing directory (e.g. `x/y/../z`).

Print:

1. the path exactly as written in the file
2. the **absolute, canonical** path of that directory (no `..`), obtained by going into it with
   `cd` and asking `pwd`
3. the path to go **from that directory back to the current one** as a relative path made only
   of `..` components separated by `/` (e.g. `../..`). The number of `..` equals the depth of the
   canonical relative path.

Hint: for 3 you may count the `/` in the canonical path relative to the start directory.
