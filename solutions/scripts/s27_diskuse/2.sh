#!/bin/bash
for d in "$1"/*/; do
  [[ -d $d ]] || continue
  d=${d%/}
  echo "$(basename "$d"): $(du -sb "$d" | cut -f1)"
done | sort -t: -k2,2nr -k1,1
exit 0
