#!/bin/bash
n=0
while read -r -a w; do
  n=$((n + 1))
  echo "line $n: ${#w[@]} words"
done < "$1"
exit 0
