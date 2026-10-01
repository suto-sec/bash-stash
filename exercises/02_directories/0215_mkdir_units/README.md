# 0215 · A course folder from a description

**Topic:** Directories & navigation · **Difficulty:** ★★★☆☆ · **Commands:** mkdir -p, seq -f, head, tail, ls

The file `course.txt` has two lines: the **name** of a course (it may contain spaces) and a number
`N` of units. For example:

```
sistemas operativos
4
```

Create, inside the current directory, the directory named after the course with:

- `unit_01`, `unit_02`, ... `unit_N` (number zero-padded to 2 digits)
- `exams/partial` and `exams/final`
- `notes`

Then print the listing of the course directory (`ls` of it, one entry per line).
