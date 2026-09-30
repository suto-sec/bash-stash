# 0744 · Safer deletion with -execdir

**Topic:** find · **Difficulty:** ★★★☆☆ · **Commands:** find -execdir, -type f, -name

Under `data`, delete every regular file literally named `tmp.dat`, anywhere in the tree, using
`-execdir` instead of `-exec`. With `-execdir`, the command runs with its **current directory**
changed to the file's own directory and `{}` is just the bare file name there — this avoids the
symlink-race problem that plain `-exec rm {}` has when someone can rename directories while `find`
is running. Print nothing; only the resulting files matter.

---
Write your solution in `answer.sh`, then run `check 0744`.  
To experiment with the same test files the checker uses: `play 0744`.
