#!/bin/bash
# bigfiles.sh DIR KB - regular files bigger than KB KiB, biggest first
if [ $# -ne 2 ]; then
  echo "Usage: $(basename "$0") DIR KB" >&2
  exit 1
fi
DIR=$1
KB=$2
[ -d "$DIR" ] || { echo "Error: '$DIR' is not a directory" >&2; exit 2; }
[[ $KB =~ ^[0-9]+$ ]] || { echo "Error: '$KB' is not a non-negative integer" >&2; exit 3; }

LIMIT=$((10#$KB * 1024))
N=0
T=0
while read -r size path; do
  echo "$size $path"
  N=$((N + 1))
  T=$((T + size))
done < <(find "$DIR" -type f -size +"${LIMIT}c" -exec stat -c '%s %n' {} + | sort -k1,1nr -k2)
echo "$N files, $T bytes"
[ "$N" -gt 0 ] || exit 4

