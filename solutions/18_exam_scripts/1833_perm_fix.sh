#!/bin/bash
# perm_fix.sh DIR MODE
usage() { echo "Usage: $(basename "$0") DIR MODE" >&2; }
[ $# -eq 2 ] || { usage; exit 1; }
DIR=$1
MODE=$2
[ -e "$DIR" ] || { echo "Error: '$DIR' does not exist" >&2; exit 2; }
[ -d "$DIR" ] || { echo "Error: '$DIR' is not a directory" >&2; exit 3; }
[[ $MODE =~ ^[0-7]{3,4}$ ]] || { echo "Error: '$MODE' is not a valid permission mode" >&2; exit 4; }
N=0; K=0
while IFS= read -r -d '' f; do
  cur=$(stat -c '%a' "$f")
  if [ "$((8#$cur))" -ne "$((8#$MODE))" ]; then
    chmod "$MODE" "$f" && { echo "fixed: $f"; N=$((N + 1)); }
  else
    K=$((K + 1))
  fi
done < <(find "$DIR" -type f -name '*.sh' -print0 | sort -z)
echo "Fixed $N files (already correct: $K)"

