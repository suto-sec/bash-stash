#!/bin/bash
if [ $# -ne 1 ]; then
  echo "Usage: $(basename "$0") ARCHIVE" >&2
  exit 1
fi
ARCH=$1
[ -e "$ARCH" ] || { echo "Error: '$ARCH' does not exist" >&2; exit 2; }
tar -tzf "$ARCH" > /dev/null 2>&1 || { echo "Error: '$ARCH' is not a valid tar.gz archive" >&2; exit 3; }

declare -A sizes
while read -r mode owner size date time name; do
  [[ $mode == d* ]] && continue
  sizes["$name"]=$size
done < <(tar -tvzf "$ARCH")

n=0
total=0
while IFS= read -r name; do
  echo "$name ${sizes[$name]}"
  n=$((n + 1))
  total=$((total + sizes[$name]))
done < <(printf '%s\n' "${!sizes[@]}" | sort)
echo "Total: $n files, $total bytes"

