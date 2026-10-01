# medium-01 · Low stock report

**Tier:** medium · **Script:** `lowstock.sh`

Write a shell script called `lowstock.sh` that takes a file and an optional threshold:

```
lowstock.sh file [threshold]
```

`file` is a CSV inventory. Its first line is a header (`item,qty,price`) and every other line is `name,qty,price`, with `qty` and `price` non-negative integers. Names contain no commas but may contain spaces. Blank lines may appear and must be ignored.

The script prints the items whose `qty` is **lower than** `threshold` (default **5**), one per line as `name: qty`, ordered by quantity from lowest to highest and, for the same quantity, by name in alphabetical order. After them it prints two summary lines:

```
Low stock items: N
Total value: V
```

where `N` is how many items were listed and `V` the sum of `qty * price` of those items (`0` and `0` if there is none; then only the two summary lines are printed).

Errors (messages go to standard error). Check them in this order:

1. No argument, or more than two: print an error message **and the correct usage**, exit code **1**.
2. `file` does not exist or is not a regular file: error message that includes its name, exit code **2**.
3. `file` is not readable: error message that includes its name, exit code **4**.
4. `threshold` is not a positive integer (only digits, at least 1): error message that includes the value, exit code **3**.

Don't forget:
- Argument checking and error messages, in the right order (3 points).
- Selecting the items, sorting them and printing them in the exact format, with the right default (4 points).
- Special cases: no low item, blank lines, names with spaces, ties in the quantity (3 points).
