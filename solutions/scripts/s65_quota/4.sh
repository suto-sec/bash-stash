#!/bin/bash
if (( $# != 2 )); then echo "Error: a directory and a limit are needed" >&2; echo "Usage: $0 dir limit" >&2; exit 1; fi
[[ -e $1 ]] || { echo "Error: $1 does not exist" >&2; exit 2; }
[[ -d $1 ]] || { echo "Error: $1 is not a directory" >&2; exit 3; }
[[ $2 =~ ^[0-9]+$ ]] || { echo "Error: '$2' is not a non-negative integer" >&2; exit 4; }
total=0
while read -r s; do
  total=$((total + s))
done < <(find "$1" -type f -printf '%s\n')
if (( $2 > 0 )); then pct=$((100 * total / $2)); elif (( total > 0 )); then pct=100; else pct=0; fi
echo "Used: $total bytes"
echo "Limit: $2 bytes"
echo "Usage: $pct%"
if (( total <= $2 )); then echo OK; exit 0; fi
echo OVER
exit 5
