#!/bin/bash
n=0; t=0
while read -ra w; do
  n=$((n + 1))
  if [ ${#w[@]} -eq 0 ]; then echo "$n: 0 words"; continue; fi
  long=
  for x in "${w[@]}"; do [ ${#x} -gt ${#long} ] && long=$x; done
  echo "$n: ${#w[@]} words, longest: $long"
  t=$((t + ${#w[@]}))
done < frases.txt
echo "total: $t words"

