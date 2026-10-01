# 1726 · Listing crontab jobs

**Topic:** Users, groups, sessions, logs & cron · **Difficulty:** ★★★☆☆ · **Commands:** crontab -l, while read, case, [[ =~ ]]

Write `cronjobs.sh [file]` that lists the **jobs** of a crontab. The crontab is read from `file`, or,
**without argument, from your own crontab** (`crontab -l`; if you have none, it is just empty: hide
the error message).

Skip empty lines, comments (first non-blank character `#`) and variable assignments (the line starts
with `NAME=`, e.g. `MAILTO=root`). For every job print:

- `<m> <h> <dom> <mon> <dow> -> <command>` for normal lines (the five time fields separated by **one**
  space, even if the file uses several spaces or tabs)
- `<@keyword> -> <command>` for lines starting with `@` (`@reboot`, `@daily`...)

where `<command>` is the rest of the line with leading/trailing blanks removed (internal spacing kept).
Finally print `N jobs`.

- more than one argument: usage on stderr, exit **2**
- the file is not a readable regular file: error message on stderr, exit **1**

(Reminder: `read -r a b rest` splits on blanks and leaves everything else in `rest`.)
