#!/bin/bash
DIR=${1:-.}
[ -d "$DIR" ] || { echo "Error: $DIR is not a directory" >&2; exit 1; }
declare -A C
for f in "$DIR"/*; do
  [ -f "$f" ] || continue
  name=$(basename "$f")
  if [[ $name == *.* ]]; then ext=${name##*.}; ext=${ext,,}; else ext=other; fi
  mkdir -p "$DIR/$ext"
  mv "$f" "$DIR/$ext/"
  C[$ext]=$(( ${C[$ext]:-0} + 1 ))
done
for e in "${!C[@]}"; do echo "$e: ${C[$e]} files"; done | sort

