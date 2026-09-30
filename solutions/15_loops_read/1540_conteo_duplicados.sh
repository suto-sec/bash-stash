#!/bin/bash
w=()
while IFS= read -r line; do w+=("$line"); done < palabras.txt

seen=()
d=0
for ((i = 0; i < ${#w[@]}; i++)); do
  word=${w[i]}
  already=0
  for s in "${seen[@]}"; do [ "$s" = "$word" ] && { already=1; break; }; done
  [ "$already" -eq 1 ] && continue
  seen+=("$word")
  n=0
  for ((j = 0; j < ${#w[@]}; j++)); do [ "${w[j]}" = "$word" ] && n=$((n + 1)); done
  if [ "$n" -gt 1 ]; then echo "$word: $n veces"; d=$((d + 1)); fi
done
echo "distintas repetidas: $d"

