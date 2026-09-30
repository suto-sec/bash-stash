#!/bin/bash
# purge_empty_dirs.sh DIR
usage() { echo "Usage: $(basename "$0") DIR" >&2; }
[ $# -eq 1 ] || { usage; exit 1; }
DIR=$1
[ -e "$DIR" ] || { echo "Error: '$DIR' does not exist" >&2; exit 2; }
[ -d "$DIR" ] || { echo "Error: '$DIR' is not a directory" >&2; exit 3; }
ALL=()
while :; do
  mapfile -d '' -t batch < <(find "$DIR" -mindepth 1 -depth -type d -empty -print0)
  [ ${#batch[@]} -eq 0 ] && break
  for d in "${batch[@]}"; do rmdir "$d" && ALL+=("$d"); done
done
N=${#ALL[@]}
if [ "$N" -gt 0 ]; then printf '%s\n' "${ALL[@]}" | sort; fi
echo "Removed $N empty directories"
