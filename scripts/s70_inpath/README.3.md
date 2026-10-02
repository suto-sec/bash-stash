`LIST` is now optional: without it the script searches your real `$PATH`. Wrong number of arguments (none, or more than two) → an error message **and the correct usage** (e.g. `Usage: inpath.sh name [list]`), exit **1**.

(In the checks the default is tried with `NAME` = `ls`: the lab's own `$PATH`.)
