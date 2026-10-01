# 1034 · The pipe

**Topic:** Pipes, xargs & command substitution · **Difficulty:** ★☆☆☆☆ · **Commands:** |, wc

A pipe `|` sends the output of the command on its left into the command on its right. `ls` prints one name per line, and `wc -l` counts lines, so together they count the entries of a directory.

Print how many entries (files and directories) the current directory has: `ls` on the left of the pipe and `wc -l` on the right. Print only the number.

Example: if the directory contains 5 entries, print `5`.

Hint: `ls | wc -l`
