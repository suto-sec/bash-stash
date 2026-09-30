#!/bin/bash
declare -A COUNT
while IFS= read -r w; do
  COUNT[$w]=$(( ${COUNT[$w]:-0} + 1 ))
done < palabras.txt
for w in "${!COUNT[@]}"; do echo "$w: ${COUNT[$w]}"; done | sort
echo "Distinct: ${#COUNT[@]}"

