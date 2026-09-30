#!/bin/bash
mkdir mezcla/texto mezcla/otros
t=0 o=0
for f in mezcla/*; do
  [ -f "$f" ] || continue
  if [[ $(file -b "$f") == *text* ]]; then
    mv "$f" mezcla/texto/; t=$((t + 1))
  else
    mv "$f" mezcla/otros/; o=$((o + 1))
  fi
done
echo "text: $t"
echo "other: $o"

