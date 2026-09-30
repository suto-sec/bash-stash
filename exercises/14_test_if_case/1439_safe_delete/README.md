# 1439 · safe_delete.sh: deleting only files older than a reference

**Topic:** test, if & case · **Difficulty:** ★★★★☆ · **Commands:** test -f -w -x -ot, for, rm, exit codes

Write `safe_delete.sh REF FILE...`: REF is a reference file; the rest are candidates. For each
candidate, in order, delete it (`rm`) and print `borrado: FILE` **only if** it is a regular file, it
is writable, it is **not** executable, and it is **older** than REF (`-ot`); otherwise print
`omitido: FILE` and leave it untouched.

Finally print `TOTAL: R borrados de N candidatos`.

Errors (stderr, wording free; check in this order): fewer than 2 arguments -> usage, exit **1**;
REF does not exist -> a message **naming it**, exit **2** (don't touch anything).

---
Write your solution in `answer.sh`, then run `check 1439`.  
To experiment with the same test files the checker uses: `play 1439`.
