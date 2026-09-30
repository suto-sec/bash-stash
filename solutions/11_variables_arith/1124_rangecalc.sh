#!/bin/bash
[ $# -ge 1 ] && [ $# -le 2 ] || { echo "Usage: $(basename "$0") FILE [THRESHOLD]" >&2; exit 1; }
FILE=$1
THRESHOLD=${2:-0}
[ -r "$FILE" ] || { echo "Error: cannot read $FILE" >&2; exit 2; }
[[ $THRESHOLD =~ ^-?[0-9]+$ ]] || { echo "Error: THRESHOLD must be an integer" >&2; exit 3; }

N=0; SUM=0; ABOVE=0; MIN=; MAX=; BAD=0; LN=0
while IFS= read -r line; do
  LN=$((LN + 1))
  [[ -z ${line// /} ]] && continue
  if [[ $line =~ ^-?[0-9]+$ ]]; then
    v=$line
    SUM=$(expr "$SUM" + "$v")
    N=$((N + 1))
    { [ -z "$MIN" ] || [ "$v" -lt "$MIN" ]; } && MIN=$v
    { [ -z "$MAX" ] || [ "$v" -gt "$MAX" ]; } && MAX=$v
    [ "$(expr "$v" \> "$THRESHOLD")" = 1 ] && ABOVE=$((ABOVE + 1))
  else
    echo "Error: line $LN: $line" >&2
    BAD=1
  fi
done < "$FILE"

[ $N -eq 0 ] && { echo "Error: no valid readings in $FILE" >&2; exit 5; }

AVG=$(echo "scale=1; $SUM / $N" | bc)
echo "Readings: $N"
echo "Min: $MIN"
echo "Max: $MAX"
echo "Sum: $SUM"
echo "Average: $AVG"
echo "Above $THRESHOLD: $ABOVE"
[ $BAD -eq 1 ] && exit 4
exit 0

