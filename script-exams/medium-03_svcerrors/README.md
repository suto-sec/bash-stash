# medium-03 · Messages per service

**Tier:** medium · **Script:** `svcerrors.sh`

Write a shell script called `svcerrors.sh` that takes a log file and an optional level:

```
svcerrors.sh file [level]
```

Every line of the log has this form (fields separated by spaces):

```
2026-03-14 09:12:01 ERROR sshd: authentication failed for user bob
```

that is: date, time, **level** (`INFO`, `WARN` or `ERROR`), the **service** followed by a colon (lower-case letters, digits and hyphens) and then a free message that may contain spaces, colons and even the words `INFO`, `WARN` or `ERROR`. The file may also contain blank lines and lines that do not follow this form (for example `-- log rotated --`): ignore them.

The script counts, for the lines whose level is **exactly** `level` (default `ERROR`), how many there are per service, and prints one line per service as `service: N`, ordered by `N` from highest to lowest and, for the same `N`, by service name in alphabetical order. After them it prints a last line:

```
Total: T
```

where `T` is the number of lines counted (`Total: 0` alone if there is none).

Errors (messages go to standard error). Check them in this order:

1. No argument, or more than two: print an error message **and the correct usage**, exit code **1**.
2. `file` does not exist or is not a regular file: error message that includes its name, exit code **2**.
3. `file` is not readable: error message that includes its name, exit code **4**.
4. `level` is not one of `INFO`, `WARN`, `ERROR` (written exactly like that): error message that includes the value, exit code **3**.

Don't forget:
- Argument checking and error messages, in the right order (3 points).
- Counting per service for the right level, with the exact format and ordering (4 points).
- Special cases: no line of that level, blank or odd lines, a level word inside a message, ties (3 points).
