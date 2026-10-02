# 2015 · Make the scripts executable

**Topic:** Exam tasks with the manual · **Difficulty:** ★★★☆☆ · **Commands:** find, chmod

The folder `herramientas` has files and subfolders. Give **owner and group** execute permission to every `.sh` file in it (any level) **without changing any other permission bit**, and without touching files that are not `.sh`.

Example: `rw-r--r--` becomes `rwxr-xr--`, and `rw-------` becomes `rwx--x---`.

One `find` with `-exec chmod` does it. The symbolic modes (`ug+x` and the other forms) are in `man chmod`.
