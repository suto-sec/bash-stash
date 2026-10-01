# 1732 · Adding a validated cron job

**Topic:** Users, groups, sessions, logs & cron · **Difficulty:** ★★★★☆ · **Commands:** crontab -l, crontab -, [[ =~ ]], grep -qxF, read

Write `cronadd.sh "SCHEDULE" "COMMAND"`, which adds the job `SCHEDULE COMMAND` (the two arguments
joined by **one** space) to **your** crontab, keeping the existing lines (the new one goes at the end).

`SCHEDULE` must have exactly **5 fields separated by single spaces**, each of them `*`, a number, or
`*/number`. Plain numbers must be in range (minute 0-59, hour 0-23, day of month 1-31, month 1-12,
day of week 0-7) and the step of `*/n` must be at least 1.

- If a line of the crontab is already **exactly** the new job: print `Already scheduled: <job>` and
  exit 0 without touching the crontab.
- Otherwise install it and print `Scheduled: <job>` and then `Your crontab has N jobs`, N being the
  number of lines of the resulting crontab that are neither empty nor comments (`#`).
- If you have no crontab yet, start from an empty one (hide `crontab -l`'s error).

Errors (message on **stderr**, crontab untouched):

- not exactly 2 arguments: usage, exit **1**
- `SCHEDULE` does not have that shape: message including the schedule, exit **2**
- a number out of range (or `*/0`): exit **3**
