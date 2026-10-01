#!/bin/bash
for f in "$1"/*; do
  [[ -f $f ]] || continue
  echo "$(stat -c %a "$f") $(basename "$f")"
done
exit 0
