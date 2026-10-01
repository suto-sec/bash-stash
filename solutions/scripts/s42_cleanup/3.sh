#!/bin/bash
dry=
if [[ $1 == -n ]]; then dry=1; shift; fi
n=0
while IFS= read -r -d '' f; do
  if [[ -n $dry ]]; then echo "would remove $f"; n=$((n + 1))
  elif rm -- "$f" 2>/dev/null; then echo "removed $f"; n=$((n + 1))
  else echo "could not remove $f" >&2; fi
done < <(find "$1" -type f \( -name "*.tmp" -o -name "*~" \) -mtime +7 -print0)
if [[ -n $dry ]]; then echo "Would remove $n files"; else echo "Removed $n files"; fi
