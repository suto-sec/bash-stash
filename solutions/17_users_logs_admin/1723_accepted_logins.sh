#!/bin/bash
# logins.sh [log] - accepted SSH logins per user
[ $# -le 1 ] || { echo "Usage: $(basename "$0") [log]" >&2; exit 2; }
LOG=${1:-/var/log/auth.log}
[ -r "$LOG" ] || { echo "Error: cannot read $LOG" >&2; exit 1; }

# "user method ip" for every accepted login, in file order
A=$(grep 'Accepted ' "$LOG" | sed -E 's/.*Accepted ([^ ]+) for ([^ ]+) from ([^ ]+) port.*/\2 \1 \3/')
TOTAL=0
for u in $(echo "$A" | cut -d' ' -f1 | sort -u); do
  L=$(echo "$A" | grep "^$u ")
  T=$(echo "$L" | wc -l)
  P=$(echo "$L" | grep -c ' password ')
  K=$(echo "$L" | grep -c ' publickey ')
  IP=$(echo "$L" | tail -n 1 | cut -d' ' -f3)
  echo "$u: $T logins ($P password, $K publickey), last from $IP"
  TOTAL=$((TOTAL + T))
done
echo "Total: $TOTAL accepted logins"

