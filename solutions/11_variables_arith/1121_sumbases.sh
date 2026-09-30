#!/bin/bash
[ $# -eq 1 ] || { echo "Usage: $(basename "$0") FILE" >&2; exit 1; }
FILE=$1
[ -r "$FILE" ] || { echo "Error: cannot read $FILE" >&2; exit 2; }

TOTAL=0 N=0 K=0 LN=0
while IFS= read -r line; do
  LN=$((LN + 1))
  [[ -z ${line// /} ]] && continue
  read -r base val rest <<< "$line"
  ok=0
  case $base in
    dec) [[ $val =~ ^[0-9]+$ ]] && [[ -z $rest ]] && { dec=$val; ok=1; } ;;
    bin) [[ $val =~ ^[01]+$ ]] && [[ -z $rest ]] && { dec=$((2#$val)); ok=1; } ;;
    oct) [[ $val =~ ^[0-7]+$ ]] && [[ -z $rest ]] && { dec=$((8#$val)); ok=1; } ;;
    hex) [[ $val =~ ^[0-9A-Fa-f]+$ ]] && [[ -z $rest ]] && { dec=$((16#$val)); ok=1; } ;;
  esac
  if [ $ok -eq 1 ]; then
    echo "$base $val = $dec"
    TOTAL=$((TOTAL + dec))
    N=$((N + 1))
  else
    echo "Error: line $LN: $line" >&2
    K=$((K + 1))
  fi
done < "$FILE"
[ $N -eq 0 ] && { echo "Error: no valid values in $FILE" >&2; exit 3; }
echo "Sum: $TOTAL"
echo "Skipped: $K"
[ $K -gt 0 ] && exit 4
exit 0

