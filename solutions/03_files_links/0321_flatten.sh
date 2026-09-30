#!/bin/bash
n=0
for d in caos/*/; do
  d=${d%/}
  for f in "$d"/*; do
    [ -f "$f" ] || continue
    mv "$f" "caos/$(basename "$d")_$(basename "$f")"
    n=$((n + 1))
  done
  rmdir "$d"
done
echo "$n files moved"

