#!/bin/bash
# sesiones.sh [file] - sessions and connected minutes per user
[ $# -le 1 ] || { echo "Usage: $(basename "$0") [file]" >&2; exit 2; }
if [ $# -eq 1 ]; then
  [ -r "$1" ] || { echo "Error: cannot read $1" >&2; exit 1; }
  DATA=$(cat "$1")
else
  DATA=$(last)
fi
DATA=$(echo "$DATA" | grep -v -e '^$' -e '^wtmp begins' -e '^reboot ')

for u in $(echo "$DATA" | cut -d' ' -f1 | sort -u); do
  L=$(echo "$DATA" | grep "^$u ")
  S=$(echo "$L" | wc -l)
  M=0
  for d in $(echo "$L" | grep -oE '\(([0-9]+\+)?[0-9]+:[0-9]+\)$' | tr -d '()'); do
    days=0
    if [[ $d == *+* ]]; then days=${d%%+*}; d=${d#*+}; fi
    M=$((M + days * 1440 + 10#${d%%:*} * 60 + 10#${d##*:}))
  done
  echo "$u: $S sessions, $M minutes"
done

