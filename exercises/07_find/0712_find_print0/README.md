# 0712 · Names with spaces

**Topic:** find · **Difficulty:** ★★★★☆ · **Commands:** find -print0, xargs -0

Under `docs` there are `.txt` files, some with **spaces** in their names. Print the **total number
of lines** of all of them (just the number).

Use `find -print0 | xargs -0 cat | wc -l`. Try a naive `cat $(find ...)` in the terminal (the exercise folder
has files with spaces too) to see why it breaks.
