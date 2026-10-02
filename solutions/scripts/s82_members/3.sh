#!/bin/bash
if (( $# != 2 )); then echo "Error: two arguments needed" >&2; echo "Usage: $0 group file" >&2; exit 1; fi
[[ -e $2 ]] || { echo "Error: $2 does not exist" >&2; exit 2; }
[[ -f $2 ]] || { echo "Error: $2 is not a regular file" >&2; exit 3; }
line=$(grep "^$1:" "$2") || { echo "Error: group $1 not found in $2" >&2; exit 4; }
echo "Group $1 (gid $(echo "$line" | cut -d: -f3))"
n=0
while IFS= read -r m; do echo "$m"; n=$((n + 1)); done < <(echo "$line" | cut -d: -f4 | tr ',' '\n' | grep .)
if (( n == 0 )); then echo "No members"; else echo "$n members"; fi
