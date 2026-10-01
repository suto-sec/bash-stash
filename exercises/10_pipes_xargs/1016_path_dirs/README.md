# 1016 · Searching in $PATH

**Topic:** Pipes, xargs & command substitution · **Difficulty:** ★★★★☆ · **Commands:** tr, xargs, find / ls

The script receives a file name as argument. Print the full path of every file with that exact name
found in the directories of `$PATH` (in `$PATH` order, one per line). Directories that don't exist
must not produce errors.

Hint: `echo "$PATH" | tr : '\n'` gives one directory per line.
