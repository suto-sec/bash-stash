#!/bin/bash
for d in "$1"/*/; do
  [[ -d $d ]] || continue
  d=${d%/}
  echo "$(basename "$d"): $(du -sb "$d" | cut -f1)"
done
exit 0
