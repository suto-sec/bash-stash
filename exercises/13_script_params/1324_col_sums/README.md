# 1324 · colsum.sh: adding up columns

**Topic:** Script parameters & exit codes · **Difficulty:** ★★★★☆ · **Commands:** option -d, shift 2, cut, head, tail, exit codes

Write `colsum.sh`:

```
colsum.sh [-d C] file col...
```

`file` is a table whose fields are separated by the character `C` (default `,`). Its **first line**
is a header with the column names; every other line is a data row whose fields are integers
(possibly negative). For every `col` (a column number, 1-based), in the order given (repetitions
allowed), print

```
<column name>: <sum of that column over all data rows>
```

and finally `Rows: N` (number of data rows).

The option `-d C` is only recognised as the **first** argument. Errors, checked in this order
(message on **stderr**, wording free, nothing on stdout):

| error | exit |
|-------|------|
| `-d` without a value, a value that is not exactly one character, or fewer than 2 arguments after the option (show the usage) | 1 |
| `file` is not a readable regular file (name it) | 2 |
| a `col` that is not a positive integer or is bigger than the number of columns of the header (name it) | 3 |

The number of columns is the number of fields of the header line with that separator (a file
separated with `;` read with the default `,` has only 1 column).
