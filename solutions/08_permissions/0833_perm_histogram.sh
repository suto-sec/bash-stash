#!/bin/bash
if [ $# -ne 1 ]; then
  echo "Usage: $(basename "$0") DIR" >&2
  exit 1
fi
DIR=$1
[ -d "$DIR" ] || { echo "Error: '$DIR' is not a directory" >&2; exit 2; }

declare -A count
total=0
while IFS= read -r m; do
  count[$m]=$(( ${count[$m]:-0} + 1 ))
  total=$((total + 1))
done < <(find "$DIR" -type f -printf '%m\n')

for m in $(printf '%s\n' "${!count[@]}" | sort); do
  echo "$m: ${count[$m]}"
done
echo "Total: $total files"

