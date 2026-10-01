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
if (( $# != 1 )); then echo "Error: exactly one directory is needed" >&2; echo "Usage: $0 [-n] [-d DAYS] dir" >&2; exit 1; fi
[[ -e $1 ]] || { echo "Error: $1 does not exist" >&2; exit 2; }
[[ -d $1 ]] || { echo "Error: $1 is not a directory" >&2; exit 3; }
n=0 bad=0
while IFS= read -r -d '' f; do
  if [[ -n $dry ]]; then echo "would remove $f"; n=$((n + 1))
  elif rm -- "$f" 2>/dev/null; then echo "removed $f"; n=$((n + 1))
  else echo "could not remove $f" >&2; bad=1; fi
done < <(find "$1" -type f \( -name "*.tmp" -o -name "*~" \) -mtime +"$days" -print0)
if [[ -n $dry ]]; then echo "Would remove $n files"; else echo "Removed $n files"; fi
(( bad == 0 )) || exit 6
