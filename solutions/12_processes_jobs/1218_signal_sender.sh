#!/bin/bash
[ $# -eq 2 ] || { echo "Usage: $(basename "$0") SIGNAL COUNT" >&2; exit 1; }
SIG=$1
N=$2
case $SIG in
  TERM|KILL|HUP|USR1|USR2) ;;
  *) echo "Error: unknown signal '$SIG'" >&2; exit 2 ;;
esac
[[ $N =~ ^[0-9]+$ ]] || { echo "Error: COUNT must be a number" >&2; exit 3; }
[ "$N" -ge 1 ] && [ "$N" -le 5 ] || { echo "Error: COUNT must be between 1 and 5" >&2; exit 4; }

declare -a PIDS CODES
for ((i = 0; i < N; i++)); do
  sleep 300 &
  PIDS[i]=$!
done
{
  kill -s "$SIG" "${PIDS[@]}"
  for ((i = 0; i < N; i++)); do
    wait "${PIDS[i]}"
    CODES[i]=$?
  done
} 2>/dev/null
T=0
for ((i = 0; i < N; i++)); do
  echo "job $((i + 1)): exit ${CODES[i]}"
  T=$((T + CODES[i]))
done
echo "sum: $T"

