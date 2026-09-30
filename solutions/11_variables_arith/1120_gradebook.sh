#!/bin/bash
usage() { echo "Usage: $(basename "$0") FILE [PASS]" >&2; exit 1; }
[ $# -ge 1 ] && [ $# -le 2 ] || usage
FILE=$1
PASS=${2:-5}
[ -r "$FILE" ] || { echo "Error: cannot read $FILE" >&2; exit 2; }
[[ $PASS =~ ^[0-9]+$ ]] && [ "$PASS" -ge 0 ] && [ "$PASS" -le 10 ] || { echo "Error: PASS must be an integer 0-10" >&2; exit 3; }

N=0 P=0 F=0 BAD=0 LN=0
while IFS= read -r line; do
  LN=$((LN + 1))
  [[ -z ${line// /} ]] && continue
  if [[ $line =~ ^([^\;]+)\;([0-9]+)\;([0-9]+)\;([0-9]+)$ ]]; then
    name=${BASH_REMATCH[1]} s1=${BASH_REMATCH[2]} s2=${BASH_REMATCH[3]} s3=${BASH_REMATCH[4]}
    if [ "$s1" -ge 1 ] && [ "$s1" -le 10 ] && [ "$s2" -ge 1 ] && [ "$s2" -le 10 ] && [ "$s3" -ge 1 ] && [ "$s3" -le 10 ]; then
      AVG=$(echo "scale=2; ($s1 + $s2 + $s3) / 3" | bc)
      if [ "$(echo "$AVG >= $PASS" | bc)" = 1 ]; then st=PASS; P=$((P + 1)); else st=FAIL; F=$((F + 1)); fi
      echo "$name: avg=$AVG ($st)"
      N=$((N + 1))
      continue
    fi
  fi
  echo "Error: line $LN: $line" >&2
  BAD=1
done < "$FILE"
echo "Total: $N students, $P passed, $F failed"
[ $BAD -eq 1 ] && exit 4
exit 0

