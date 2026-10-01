#!/bin/bash
n=0 t=0
while read -r -a w; do
  n=$((n + 1)); t=$((t + ${#w[@]}))
  echo "line $n: ${#w[@]} words"
done < "$1"
echo "total: $t words"
