#!/bin/bash
clasifica() {
  local v=$1
  if [ "$v" -lt 0 ]; then echo negativo
  elif [ "$v" -eq 0 ]; then echo cero
  elif [ "$v" -lt 10 ]; then echo bajo
  elif [ "$v" -lt 100 ]; then echo medio
  else echo alto
  fi
}
declare -A CNT
t=0
while read -r v; do
  cat=$(clasifica "$v")
  echo "$v: $cat"
  CNT[$cat]=$(( ${CNT[$cat]:-0} + 1 ))
  t=$((t + 1))
done < medidas.txt
for c in "${!CNT[@]}"; do echo "$c: ${CNT[$c]}"; done | sort
echo "total: $t"

