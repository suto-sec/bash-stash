# 1725 · Connected minutes from `last`

**Topic:** Users, groups, sessions, logs & cron · **Difficulty:** ★★★☆☆ · **Commands:** last, grep -oE, sed, $(( 10# ))

Write `sesiones.sh [file]`. The file contains the output of `last`; **without argument, use the
output of the `last` command itself**. Ignore empty lines, the `wtmp begins ...` line and lines
starting with `reboot`. Every other line is one session, and its first word is the user name.

A **closed** session ends with its duration in parentheses: `(hh:mm)`, or `(D+hh:mm)` when it lasted
more than a day. Sessions that are `still logged in` or `gone - no logout` have no duration.

For each user, sorted by name, print:

```
<user>: <S> sessions, <M> minutes
```

where S = number of sessions and M = sum of the durations of the closed ones, in minutes
(`(1+02:03)` = 1440 + 123 = 1563).

- more than one argument: usage on stderr, exit **2**
- the file cannot be read: error message on stderr, exit **1**

---
Write your solution in `answer.sh`, then run `check 1725`.  
To experiment with the same test files the checker uses: `play 1725`.
