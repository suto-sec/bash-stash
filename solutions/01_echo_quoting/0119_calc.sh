#!/bin/bash
# calc.sh A OP B
if [ $# -ne 3 ]; then
  echo "Usage: $(basename "$0") A OP B   (OP: + - x '*' / %)" >&2
  exit 1
fi
A=$1 OP=$2 B=$3
for n in "$A" "$B"; do
  if [[ ! $n =~ ^-?[0-9]+$ ]]; then
    echo "Error: '$n' is not an integer" >&2
    exit 2
  fi
done
case $OP in
  +) R=$((A + B)) ;;
  -) R=$((A - B)) ;;
  x|\*) R=$((A * B)) ;;
  /|%)
    if [ "$B" -eq 0 ]; then echo "Error: division by zero" >&2; exit 4; fi
    if [ "$OP" = / ]; then R=$((A / B)); else R=$((A % B)); fi
    ;;
  *) echo "Error: unknown operator '$OP'" >&2; exit 3 ;;
esac
echo "$A $OP $B = $R"
if (( R % 2 == 0 )); then echo "$R is even"; else echo "$R is odd"; fi

