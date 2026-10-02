#!/bin/bash
if (( $# < 1 || $# > 2 )); then echo "Error: wrong number of arguments" >&2; echo "Usage: $0 file [n]" >&2; exit 1; fi
[[ -e $1 ]] || { echo "Error: $1 does not exist" >&2; exit 2; }
[[ -f $1 ]] || { echo "Error: $1 is not a regular file" >&2; exit 3; }
top=${2:-5}
[[ $top =~ ^[0-9]+$ ]] && (( top >= 1 )) || { echo "Error: $top is not a positive integer" >&2; exit 4; }
tr -cs 'A-Za-z' '\n' < "$1" | tr 'A-Z' 'a-z' | sort | uniq -c | sort -k1,1nr -k2,2 | head -n "$top" | while read -r n w; do echo "$w: $n"; done
exit 0
