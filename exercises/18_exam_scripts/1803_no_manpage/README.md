# 1803 · Binaries without a man page

**Topic:** Exam-style scripts · **Difficulty:** ★★★☆☆ · **Commands:** for, test -e, sort

Write `sinman.sh [bindir] [mandir]` (defaults: `/bin` and `/usr/share/man/man1`) that prints, sorted,
the names of the files in `bindir` that **don't** have a page `mandir/NAME.1.gz`, followed by a line
`Total: N files without man page`.

If either directory doesn't exist: message on stderr, exit 1. More than 2 arguments: usage on stderr,
exit 1.

---
Write your solution in `answer.sh`, then run `check 1803`.  
To experiment with the same test files the checker uses: `play 1803`.
