#!/bin/bash
[ $# -eq 1 ] || { echo "Usage: $(basename "$0") FILE" >&2; exit 1; }
FILE=$1
[ -r "$FILE" ] || { echo "Error: cannot read $FILE" >&2; exit 2; }

N=0; SUM=0; BAD=0; LN=0
while IFS= read -r line; do
  LN=$((LN + 1))
  [[ -z ${line// /} ]] && continue
  if [[ $line =~ ^[0-9]+$ ]] && [ "$line" -le 255 ]; then
    SUM=$((SUM + line))
    N=$((N + 1))
  else
    echo "Error: line $LN: $line" >&2
    BAD=1
  fi
done < "$FILE"

[ $N -eq 0 ] && { echo "Error: no valid bytes in $FILE" >&2; exit 3; }

CHK=$((SUM % 256))
BIN=""
n=$CHK
for ((i = 0; i < 8; i++)); do
  BIN="$((n % 2))$BIN"
  n=$((n / 2))
done

echo "Bytes: $N"
echo "Sum: $SUM"
echo "Checksum (dec): $CHK"
printf 'Checksum (hex): %02x\n' "$CHK"
echo "Checksum (bin): $BIN"
[ $BAD -eq 1 ] && exit 4
exit 0
