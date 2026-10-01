If more than one argument is given (`greet.sh Ana Bob`), the script must print an error message **and the correct usage** on standard error (`>&2`) and exit with code **1**. Nothing goes to standard output in that case.

`$#` is the number of arguments; `exit 1` ends the script with that code.
