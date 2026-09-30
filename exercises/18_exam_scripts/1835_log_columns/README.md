# 1835 · Counting log lines by level

**Topic:** Exam-style scripts · **Difficulty:** ★★★★☆ · **Commands:** cut -d' ', sort, uniq -c

Write `log_columns.sh LOGFILE`. Every line of `LOGFILE` has the form `TIMESTAMP LEVEL MESSAGE...`
(fields separated by single spaces: `TIMESTAMP` and `LEVEL` are always exactly one field each,
`MESSAGE` is the rest of the line). Print, for every distinct `LEVEL` that appears, one line
`<LEVEL> <count>` — sorted by count **descending**, ties broken by `LEVEL` alphabetically
(ascending, case-sensitive). Finally print `Total: N lines`.

Checks, in this order:
- not exactly 1 argument: usage on stderr, exit **1**.
- `LOGFILE` is not a readable regular file: message on stderr (naming `LOGFILE`), exit **2**.

---
Write your solution in `answer.sh`, then run `check 1835`.  
To experiment with the same test files the checker uses: `play 1835`.
