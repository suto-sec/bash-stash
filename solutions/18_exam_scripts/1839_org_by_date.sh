#!/bin/bash
# org_by_date.sh DIR
usage() { echo "Usage: $(basename "$0") DIR" >&2; }
[ $# -eq 1 ] || { usage; exit 1; }
DIR=$1
[ -d "$DIR" ] || { echo "Error: '$DIR' is not a directory" >&2; exit 2; }
declare -A C
N=0
for f in "$DIR"/*; do
  [ -f "$f" ] || continue
  name=$(basename "$f")
  bucket=$(date -r "$f" +%Y-%m)
  mkdir -p "$DIR/$bucket"
  mv "$f" "$DIR/$bucket/"
  echo "$name -> $bucket/$name"
  C[$bucket]=$(( ${C[$bucket]:-0} + 1 ))
  N=$((N + 1))
done
for b in "${!C[@]}"; do echo "$b: ${C[$b]} files"; done | sort
echo "Total: $N files organized"

