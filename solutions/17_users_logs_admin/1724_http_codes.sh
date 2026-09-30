#!/bin/bash
# httpcodes.sh [access_log]
[ $# -le 1 ] || { echo "Usage: $(basename "$0") [access_log]" >&2; exit 2; }
LOG=${1:-/var/log/apache2/access.log}
[ -r "$LOG" ] || { echo "Error: cannot read $LOG" >&2; exit 1; }

TR=0; TB=0
for code in $(cut -d' ' -f9 "$LOG" | sort -n -u); do
  n=0; b=0
  for size in $(cut -d' ' -f9,10 "$LOG" | grep "^$code " | cut -d' ' -f2); do
    n=$((n + 1))
    [ "$size" != - ] && b=$((b + size))
  done
  echo "$code $n $b"
  TR=$((TR + n)); TB=$((TB + b))
done
echo "total $TR $TB"

