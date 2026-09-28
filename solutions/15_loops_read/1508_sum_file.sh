#!/bin/bash
T=0
declare -A C
while read -r cat amt; do
  T=$((T + amt))
  C[$cat]=$(( ${C[$cat]:-0} + amt ))
done < gastos.txt
echo "total: $T"
for k in "${!C[@]}"; do echo "$k: ${C[$k]}"; done | sort

