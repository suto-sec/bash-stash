#!/bin/bash
[ $# -eq 1 ] || { echo "Usage: $(basename "$0") FILE" >&2; exit 1; }
FILE=$1
[ -r "$FILE" ] || { echo "Error: cannot read $FILE" >&2; exit 2; }

declare -A QTY PRICE
BAD=0 LN=0
while IFS= read -r line; do
  LN=$((LN + 1))
  [[ -z ${line// /} ]] && continue
  read -r sym qty price rest <<< "$line"
  if [[ $sym =~ ^[A-Z]{1,5}$ ]] && [[ $qty =~ ^[0-9]+$ ]] && [ "$qty" -ge 1 ] \
     && [[ $price =~ ^[0-9]+\.[0-9]{2}$ ]] && [ -z "$rest" ]; then
    QTY[$sym]=$(( ${QTY[$sym]:-0} + qty ))
    PRICE[$sym]=$price
  else
    echo "Error: line $LN: $line" >&2
    BAD=1
  fi
done < "$FILE"

[ ${#QTY[@]} -eq 0 ] && { echo "Error: no valid holdings in $FILE" >&2; exit 3; }

TOTAL=0
for sym in $(printf '%s\n' "${!QTY[@]}" | sort); do
  v=$(echo "scale=2; ${QTY[$sym]} * ${PRICE[$sym]}" | bc)
  echo "$sym: ${QTY[$sym]} units, value=$v"
  TOTAL=$(echo "scale=2; $TOTAL + $v" | bc)
done
echo "Total portfolio value: $TOTAL"
[ $BAD -eq 1 ] && exit 4
exit 0

