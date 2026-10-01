Log lines look like `2024-03-05 10:15:02 ERROR something failed`: date, time, **level**, message. Write `loglevels.sh FILE`: it prints `ERROR: N`, where N is the number of lines whose level (3rd word) is `ERROR`.

`grep -c " ERROR " file` counts them (the spaces avoid matching words inside messages).
