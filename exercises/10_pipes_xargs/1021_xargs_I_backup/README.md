# 1021 · Backups from a list with xargs -I

**Topic:** Pipes, xargs & command substitution · **Difficulty:** ★★★☆☆ · **Commands:** xargs -I{}, cp, find, sort

`lista.txt` contains file paths, one per line, relative to the current directory. Some contain
**spaces**. Using `xargs -I{}` reading from `lista.txt`, make a copy of every listed file with the
same name plus `.bak`, in the same directory (`notes 1.txt` → `notes 1.txt.bak`). Files that are
not in the list must not be copied.

Then print all the `.bak` files under the current directory, sorted, as `find .` prints them.

Note: with `-I{}`, `xargs` takes **whole lines** as arguments, so spaces are no problem.
