#!/bin/bash
total=$(wc -l < "$1")
k=0
for ((a = 1; a <= total; a += $2)); do
  k=$((k + 1))
  sed -n "${a},$((a + $2 - 1))p" "$1" > "$1.part$k"
  echo "Created $1.part$k"
done
exit 0
