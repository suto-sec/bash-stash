# 1030 · colfreq.sh (most frequent values of a CSV column)

**Topic:** Pipes, xargs & command substitution · **Difficulty:** ★★★★☆ · **Commands:** head -1 | tr | grep -nx, cut -f, sort | uniq -c | sort -nr

Write `colfreq.sh`:

```
colfreq.sh FILE COLUMN [N]
```

`FILE` is a CSV file: the first line is a header with the column names, fields are separated by `,`
(no quotes, no empty fields; names and values may contain spaces). `COLUMN` is the **name** of a
column. Print the `N` (default **5**) most frequent values of that column, most frequent first,
ties by value in alphabetical order (as `sort` orders them), as

```
<value>: <count>
```

(if there are fewer than `N` distinct values, print them all). Finish with
`<D> distinct values in <R> rows` (`R` = data lines, without the header).

Hint: the column number is the line number of `COLUMN` in `head -n 1 FILE | tr , '\n'` (`grep -nxF`).

Validation, in this order (message on **stderr**):

- fewer than 2 or more than 3 arguments: usage, exit **1**
- `FILE` is not a readable regular file: exit **2**
- `COLUMN` is not a column of the header: exit **3** (the message must include the column name)
- `N` is not a positive integer (1, 2, ...): exit **4**

---
Write your solution in `answer.sh`, then run `check 1030`.  
To experiment with the same test files the checker uses: `play 1030`.
