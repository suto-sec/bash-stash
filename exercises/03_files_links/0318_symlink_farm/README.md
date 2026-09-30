# 0318 · A directory of symbolic links

**Topic:** Files, copies & links · **Difficulty:** ★★★☆☆ · **Commands:** mkdir, ln -s, basename, readlink

The directory `scripts` contains shell scripts (`*.sh`) and other files. Create the directory `bin`
and, inside it, for every **regular file** `scripts/NAME.sh`, a symbolic link `bin/NAME` (the name
without `.sh`) whose **stored target** is the relative path `../scripts/NAME.sh`.

Then print one line `NAME -> TARGET` for every link in `bin`, in the order of the `bin/*` glob,
where `TARGET` is the target stored in the link. Names may contain spaces.

---
Write your solution in `answer.sh`, then run `check 0318`.  
To experiment with the same test files the checker uses: `play 0318`.
