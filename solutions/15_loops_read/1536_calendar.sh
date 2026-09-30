#!/bin/bash
# calendario.sh DAYS FIRST
[ $# -eq 2 ] || { echo "usage: $(basename "$0") DAYS FIRST" >&2; exit 1; }
for v in "$1" "$2"; do
  [[ $v =~ ^[0-9]+$ ]] || { echo "error: '$v' is not an integer" >&2; exit 2; }
done
D=$((10#$1)); F=$((10#$2))
(( D >= 28 && D <= 31 )) || { echo "error: bad number of days '$1'" >&2; exit 3; }
(( F >= 1 && F <= 7 )) || { echo "error: bad weekday '$2'" >&2; exit 3; }

echo "Mo Tu We Th Fr Sa Su"
W=0; E=0; day=1; col=1
line=
for ((col = 1; col < F; col++)); do line+="   "; done
for ((day = 1; day <= D; day++)); do
  line+=$(printf '%2d ' $day)
  (( col >= 6 )) && E=$((E + 1))
  if (( col == 7 || day == D )); then
    echo "${line% }"; W=$((W + 1)); line=; col=1
  else
    col=$((col + 1))
  fi
done
echo "weeks: $W, weekend days: $E"

