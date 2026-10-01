# 0813 · Copying permissions from another tree

**Topic:** Permissions, chmod, umask, chown · **Difficulty:** ★★★☆☆ · **Commands:** stat -c %a, chmod, basename, test -e

The directories `orig` and `dest` contain files with the same names (plus some extra files in `dest`).
For every **regular file** `dest/NAME` (order of the `dest/*` glob):

- its wanted mode is the mode of `orig/NAME` if that file exists, or `600` otherwise
- if its current mode is different, change it and print `NAME: OLD -> NEW` (octal, as `stat -c %a`
  shows them)

Finally print `N changed`. Names may contain spaces.
