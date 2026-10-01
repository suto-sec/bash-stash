#!/bin/bash
total=0
while read -r s; do
  total=$((total + s))
done < <(find "$1" -type f -printf '%s\n')
echo "Used: $total bytes"
