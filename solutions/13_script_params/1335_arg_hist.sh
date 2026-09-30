#!/bin/bash
declare -A CNT
for a in "$@"; do
  CNT[$a]=$(( ${CNT[$a]:-0} + 1 ))
done
for k in "${!CNT[@]}"; do echo "$k: ${CNT[$k]}"; done | sort
echo "total: $# argumentos, ${#CNT[@]} distintos"

