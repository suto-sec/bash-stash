# 1511 · Menus with select

**Topic:** Loops: for, while, until, read · **Difficulty:** ★★★☆☆ · **Commands:** select, case, break, PS3

Show a menu with `select opt in listar contar salir` (the menu and `PS3` prompt go to stderr).
The user's choices come from stdin, one per line:

- `listar` (1): print the files of the current directory (`ls`)
- `contar` (2): print `N files`
- `salir` (3): print `bye` and leave the loop
- invalid number: print `invalid option`

If stdin ends without choosing `salir`, the loop ends by itself (select stops at EOF).
