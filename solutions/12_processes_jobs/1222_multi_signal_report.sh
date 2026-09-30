#!/bin/bash
[ $# -eq 1 ] || { echo "Usage: $(basename "$0") SIGLIST" >&2; exit 1; }
IFS=',' read -ra SIGS <<< "$1"
N=${#SIGS[@]}
[ "$N" -ge 1 ] && [ "$N" -le 4 ] || { echo "Error: expected 1 to 4 signals, got $N" >&2; exit 2; }
for s in "${SIGS[@]}"; do
  case $s in
    TERM|KILL|HUP|USR1|USR2) ;;
    *) echo "Error: unknown signal '$s'" >&2; exit 3 ;;
  esac
done

T=0
for s in "${SIGS[@]}"; do
  sleep 300 &
  P=$!
  kill -s "$s" "$P"
  wait "$P" 2>/dev/null
  C=$?
  echo "$s: exit $C"
  T=$((T + C))
done
echo "signals: $N"
echo "sum: $T"
