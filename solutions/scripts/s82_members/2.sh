#!/bin/bash
if (( $# != 2 )); then echo "Error: two arguments needed" >&2; echo "Usage: $0 group file" >&2; exit 1; fi
[[ -e $2 ]] || { echo "Error: $2 does not exist" >&2; exit 2; }
[[ -f $2 ]] || { echo "Error: $2 is not a regular file" >&2; exit 3; }
grep -q "^$1:" "$2" || { echo "Error: group $1 not found in $2" >&2; exit 4; }
grep "^$1:" "$2" | cut -d: -f4 | tr ',' '\n' | grep .
exit 0
