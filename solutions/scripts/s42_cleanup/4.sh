#!/bin/bash
dry= days=7
while [[ $1 == -* ]]; do
  case $1 in
    -n) dry=1; shift ;;
    -d)
      [[ $2 =~ ^[1-9][0-9]*$ ]] || { echo "Error: '$2' is not a positive integer" >&2; exit 4; }
      days=$2; shift 2 ;;
    *) echo "Error: unknown option '$1'" >&2; exit 5 ;;
  esac
done
n=0
while IFS= read -r -d '' f; do
  if [[ -n $dry ]]; then echo "would remove $f"; n=$((n + 1))
  elif rm -- "$f" 2>/dev/null; then echo "removed $f"; n=$((n + 1))
  else echo "could not remove $f" >&2; fi
done < <(find "$1" -type f \( -name "*.tmp" -o -name "*~" \) -mtime +"$days" -print0)
if [[ -n $dry ]]; then echo "Would remove $n files"; else echo "Removed $n files"; fi
