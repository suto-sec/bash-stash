#!/bin/bash
[ $# -eq 2 ] || { echo "Usage: $(basename "$0") POLL_TENTHS MAX_POLLS" >&2; exit 1; }
PT=$1
MP=$2
[[ $PT =~ ^[0-9]+$ ]] && [ "$PT" -ge 1 ] || { echo "Error: POLL_TENTHS must be a positive integer" >&2; exit 2; }
[[ $MP =~ ^[0-9]+$ ]] && [ "$MP" -ge 1 ] || { echo "Error: MAX_POLLS must be a positive integer" >&2; exit 3; }

./worker.sh &
P=$!
for ((i = 0; i < MP; i++)); do
  [ -e done.flag ] && break
  sleep "0.$PT"
done
if [ -e done.flag ]; then
  echo "worker finished"
  cat done.flag
  wait "$P" 2>/dev/null
else
  kill -9 "$P" 2>/dev/null
  wait "$P" 2>/dev/null
  echo "Error: worker did not finish in time" >&2
  exit 4
fi

