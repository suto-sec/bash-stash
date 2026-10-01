# 1438 · dir_chain.sh: validating a chain of nested directories

**Topic:** test, if & case · **Difficulty:** ★★★★☆ · **Commands:** test -d, for, exit codes

Write `dir_chain.sh NAME1 [NAME2 ...]`: each argument is one path **component** (not a full path);
build the path incrementally, joining them with `/` (`NAME1`, then `NAME1/NAME2`, then
`NAME1/NAME2/NAME3`, ...) and, **in order**, check that each partial path is an existing directory.

Stop at the **first level** that fails and print, on stderr, a message **naming that partial path**
and exit **2**. If every level is a directory, print `cadena valida: FULLPATH` (FULLPATH = the
complete joined path) and exit 0.

With no arguments, print a usage message on stderr and exit 1.
