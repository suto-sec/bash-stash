Write `execlist.sh DIR`. It prints the path (as `find` shows it) of every **regular file** below `DIR` (any depth) whose name ends in `.sh` and that has **some execute permission** (for the owner, the group or the others). The order does not matter.

`find DIR -type f -name "*.sh" -perm /111`.
