#!/bin/bash
t=()
while read -r x; do t+=("$x"); done < temps.txt
n=${#t[@]}
for ((i = 2; i < n; i++)); do
  a=${t[i-2]} b=${t[i-1]} c=${t[i]}
  echo "$((i + 1)): $a $b $c -> $(( (a + b + c) / 3 ))"
done
best=
for ((i = 0; i < n - 1; i++)); do
  d=$(( t[i+1] - t[i] ))
  if [ -z "$best" ] || [ $d -gt $best ]; then best=$d; bi=$((i + 1)); fi
done
echo "max rise: $best (line $bi -> $((bi + 1)))"

