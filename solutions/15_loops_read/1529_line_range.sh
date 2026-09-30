#!/bin/bash
# lineas.sh FILE FROM TO
if [ $# -ne 3 ]; then
  echo "usage: $(basename "$0") FILE FROM TO" >&2; exit 1
fi
if [ ! -f "$1" ] || [ ! -r "$1" ]; then
  echo "error: '$1' is not a readable file" >&2; exit 2
fi
for v in "$2" "$3"; do
  if [[ ! $v =~ ^[0-9]+$ ]] || (( 10#$v < 1 )); then
    echo "error: '$v' is not a positive integer" >&2; exit 3
  fi
done
from=$((10#$2)); to=$((10#$3))
[ $from -le $to ] || { echo "error: FROM ($from) > TO ($to)" >&2; exit 4; }

n=0; k=0
while IFS= read -r line || [ -n "$line" ]; do
  n=$((n + 1))
  [ $n -lt $from ] && continue
  echo "$n: $line"; k=$((k + 1))
  [ $n -ge $to ] && break
done < "$1"
echo "printed $k lines"

