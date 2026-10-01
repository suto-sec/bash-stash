#!/bin/bash
total=0
while read -r s; do
  total=$((total + s))
done < <(find "$1" -type f -printf '%s\n')
echo "Used: $total bytes"
echo "Limit: $2 bytes"
if (( total <= $2 )); then echo OK; else echo OVER; fi
