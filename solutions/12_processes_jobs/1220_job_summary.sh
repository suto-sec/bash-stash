#!/bin/bash
[ $# -eq 1 ] || { echo "Usage: $(basename "$0") COUNT" >&2; exit 1; }
N=$1
[[ $N =~ ^[0-9]+$ ]] || { echo "Error: COUNT must be a number" >&2; exit 2; }
[ "$N" -ge 1 ] && [ "$N" -le 6 ] || { echo "Error: COUNT must be between 1 and 6" >&2; exit 3; }

CODES=()
while IFS= read -r c; do CODES+=("$c"); done < codes.txt

declare -a PIDS
for ((i = 0; i < N; i++)); do
  (exit "${CODES[i]}") &
  PIDS[i]=$!
done
OK=0
for ((i = 0; i < N; i++)); do
  wait "${PIDS[i]}"
  C=$?
  echo "job $((i + 1)): exit $C"
  [ "$C" -eq 0 ] && OK=$((OK + 1))
done
echo "successes: $OK"
echo "failures: $((N - OK))"
echo "total: $N"

