# 0220 · Symlinked directories: pwd -L vs pwd -P

**Topic:** Directories & navigation · **Difficulty:** ★★★☆☆ · **Commands:** cd, cd -P, pwd -P, ln -s

The current directory contains a directory tree `real/X/Y` and a **symbolic link** `atajo` that points
to `real/X/Y` (`X` and `Y` change on every run). The shell remembers **how** you reached a
directory (the logical path) unless you ask for the physical one.

Print, in this order:

1. after `cd atajo`: the output of `pwd` (logical: ends in `/atajo`)
2. the output of `pwd -P` (physical: ends in `/real/X/Y`)
3. after `cd ..` (from there): `pwd` (logical `..` goes back to the directory that contains `atajo`)
4. after going **physically** into the link with `cd -P atajo` and then `cd ..`: `pwd`
   (now `..` is `real/X`)
