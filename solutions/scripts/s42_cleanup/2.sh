#!/bin/bash
n=0
while IFS= read -r -d '' f; do
  if rm -- "$f" 2>/dev/null; then echo "removed $f"; n=$((n + 1)); else echo "could not remove $f" >&2; fi
done < <(find "$1" -type f \( -name "*.tmp" -o -name "*~" \) -mtime +7 -print0)
echo "Removed $n files"
