Write `upperfile.sh FILE`. It creates `FILE.upper` (next to it) with the content of `FILE` converted to upper case, and prints `Created FILE.upper`.

`tr a-z A-Z < "$1" > "$1.upper"`.
