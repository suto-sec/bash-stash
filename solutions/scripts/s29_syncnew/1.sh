#!/bin/bash
for f in "$1"/*; do
  [[ -f $f ]] || continue
  cp -- "$f" "$2/" 2>/dev/null && echo "copied $(basename "$f")"
done
exit 0
