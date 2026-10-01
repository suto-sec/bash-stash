# 1430 · datecheck.sh: validating calendar dates

**Topic:** test, if & case · **Difficulty:** ★★★★☆ · **Commands:** [[ =~ ]], case, $((10#...)), leap years, exit codes

Write `datecheck.sh`:

```
datecheck.sh date...
datecheck.sh -          (read the dates from stdin, one per line)
```

With `-` as the **only** argument the dates are the non-empty lines of standard input; otherwise
they are the arguments. For each date print `<date>: ok` or `<date>: invalid <what>`, where
`<what>` is the **first** failing check:

1. `format`: must be exactly `YYYY-MM-DD` (4, 2 and 2 digits)
2. `year`: 1900 to 2099
3. `month`: 01 to 12
4. `day`: 01 to the number of days of that month (February has 29 days in leap years: divisible by
   4 and not by 100, or divisible by 400)

Finally print `V valid, I invalid`.

Exit codes: **0** all dates valid (also when there are none), **1** some invalid, **2** no arguments
(usage on stderr). Careful with `08`/`09` in `$(( ))`.
