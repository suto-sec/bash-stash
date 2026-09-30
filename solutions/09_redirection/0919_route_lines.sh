#!/bin/bash
a=0 b=0 c=0
exec 3> numbers.txt 4> names.txt
while IFS= read -r l; do
  if [ -z "$l" ]; then
    continue
  elif [[ $l =~ ^[0-9]+$ ]]; then
    echo "$l" >&3; a=$((a + 1))
  elif [[ $l =~ ^[A-Z] ]]; then
    echo "$l" >&4; b=$((b + 1))
  else
    echo "skipped: $l" >&2; c=$((c + 1))
  fi
done
exec 3>&- 4>&-
echo "$a numbers, $b names, $c skipped"

