# 2003 · Big and old

**Topic:** Exam tasks with the manual · **Difficulty:** ★★★☆☆ · **Commands:** find

The folder `logs` (with a subfolder `viejos`) has files of different sizes and ages.

Print the path of every regular file that is **bigger than 2 KiB** and was **last modified more than 7 days ago**. One per line, in alphabetical order.

Look at what `-size` and `-mtime` mean exactly in `man find`: how `+` and `-` work, the units (`k`, `M`, `c`) and how the days are counted.
