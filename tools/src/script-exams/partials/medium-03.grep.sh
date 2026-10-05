#!/bin/bash
# expect: 3..8
# arguments are checked, but the level is looked for anywhere in the line and the order of ties is not defined
if (( $# < 1 || $# > 2 )); then echo "Error: wrong number of arguments" >&2; echo "Usage: $0 file [level]" >&2; exit 1; fi
file=$1 level=${2:-ERROR}
[[ -f $file ]] || { echo "Error: $file does not exist" >&2; exit 2; }
[[ -r $file ]] || { echo "Error: cannot read $file" >&2; exit 4; }
case $level in INFO|WARN|ERROR) ;; *) echo "Error: invalid level '$level'" >&2; exit 3 ;; esac
grep "$level" "$file" | cut -d' ' -f4 | tr -d ':' | sort | uniq -c | sort -rn | awk '{ print $2 ": " $1; t += $1 } END { print "Total: " t + 0 }'
