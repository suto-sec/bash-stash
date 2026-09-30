#!/bin/bash
A=$1 B=$2
if cmp -s "$A" "$B"; then
  echo identical; exit 0
fi
if diff -w -q "$A" "$B" > /dev/null; then
  echo "same except whitespace"; exit 1
fi
out=$(cmp "$A" "$B" 2>&1)
case $out in
  *"EOF on $A "*) echo "$A is a prefix of $B"; exit 2 ;;
  *"EOF on $B "*) echo "$B is a prefix of $A"; exit 2 ;;
esac
echo "differ at $(echo "$out" | sed 's/.* differ: //')"
exit 3

