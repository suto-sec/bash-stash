#!/bin/bash
[ $# -eq 1 ] || { echo "Usage: $(basename "$0") MAX_RESTARTS" >&2; exit 1; }
MAX=$1
[[ $MAX =~ ^[0-9]+$ ]] || { echo "Error: MAX_RESTARTS must be a number" >&2; exit 2; }
[ "$MAX" -ge 1 ] && [ "$MAX" -le 5 ] || { echo "Error: MAX_RESTARTS must be between 1 and 5" >&2; exit 3; }

for ((n = 1; n <= MAX; n++)); do
  ./worker.sh &
  wait $!
  C=$?
  echo "attempt $n: exit $C"
  if [ "$C" -eq 0 ]; then
    echo "succeeded after $n attempts"
    exit 0
  fi
done
echo "gave up after $MAX attempts"
exit 10

