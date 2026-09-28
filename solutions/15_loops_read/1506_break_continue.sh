#!/bin/bash
n=0
for x in "$@"; do
  [ "$x" -lt 0 ] && continue
  [ "$x" -eq 0 ] && break
  echo "$x"
  n=$((n + 1))
done
echo "processed: $n"

