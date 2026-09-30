#!/bin/bash
n=0
for f in dest/*; do
  [ -f "$f" ] || continue
  name=$(basename "$f")
  if [ -e "orig/$name" ]; then want=$(stat -c %a "orig/$name"); else want=600; fi
  old=$(stat -c %a "$f")
  if [ "$old" != "$want" ]; then
    chmod "$want" "$f"
    echo "$name: $old -> $want"
    n=$((n + 1))
  fi
done
echo "$n changed"

