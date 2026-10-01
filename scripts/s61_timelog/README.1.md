Every line of the log starts with the time `HH:MM:SS`. Write `timelog.sh LOG`. For each hour that has events print `HH: N` (the two-digit hour and how many lines), sorted by hour. An empty log prints nothing.

`${line:0:2}` is the hour; an associative array counts them.
