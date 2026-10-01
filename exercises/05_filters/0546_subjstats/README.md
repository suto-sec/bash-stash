# 0546 · subjstats.sh (grades per subject)

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★★★☆ · **Commands:** grep -v, cut, sort -u, sort -t -k, head, wc -l

Write `subjstats.sh`:

```
subjstats.sh FILE [SUBJECT]
```

`FILE` has lines `student;subject;grade` (grade: integer 0-10; subjects may contain spaces).
Lines starting with `#` and empty lines are ignored.

For every subject (alphabetically, as `sort` orders them), or only for `SUBJECT` if it is given,
print:

```
<subject>: <n> grades, best <student> (<grade>), worst <student> (<grade>), <p> passed
```

- `best`: the highest grade; if several students have it, the first **student name** in `sort` order
- `worst`: the lowest grade; if tied, also the first student name in `sort` order
- `passed`: number of grades ≥ 5

Subjects are compared exactly (`SO` is not `SO2`). Finally print `Subjects: S, grades: G` (for the
subjects printed). A file with no data prints only `Subjects: 0, grades: 0`.

Errors (message on **stderr**, nothing on stdout):

- not 1 or 2 arguments: error and usage, exit **1**
- `FILE` is not a readable regular file: message with its name, exit **2**
- `SUBJECT` does not appear in the file: message with the subject, exit **3**
