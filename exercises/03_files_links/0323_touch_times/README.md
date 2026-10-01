# 0323 · Playing with timestamps

**Topic:** Files, copies & links · **Difficulty:** ★★★☆☆ · **Commands:** touch -d, touch -r, ls -t

The current directory contains `a.txt`, `b.txt`, `c.txt`, `d.txt` and a file `fecha` holding one
date like `2021-03-14 09:26`.

1. Set the modification time of `c.txt` to the date written in `fecha`.
2. Give `b.txt` exactly the same modification time as `a.txt`.
3. Create the file `nuevo.txt` with the same modification time as `c.txt` (after step 1).
4. Print the names of all the `*.txt` files, one per line, **newest first**; files with the same
   time are printed in alphabetical order (`ls -t` does exactly this).

The checker compares the modification times of every file.
