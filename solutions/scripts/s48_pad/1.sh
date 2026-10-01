#!/bin/bash
n=0
while IFS= read -r line; do
  n=$((n + 1))
  printf '%03d %s\n' "$n" "$line"
done < "$1"
