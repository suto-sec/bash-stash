#!/bin/bash
# countperm.sh DIR MODE
usage() { echo "Usage: $(basename "$0") DIR MODE" >&2; }
[ $# -eq 2 ] || { usage; exit 1; }
DIR=$1
MODE=$2
[ -d "$DIR" ] || { echo "Error: '$DIR' is not a directory" >&2; exit 2; }
[[ $MODE =~ ^[0-7]{3,4}$ ]] || { echo "Error: '$MODE' is not a valid permission mode" >&2; exit 3; }
R=$(find "$DIR" -type f -perm "$MODE" | sort)
[ -n "$R" ] && echo "$R"
N=$(find "$DIR" -type f -perm "$MODE" | wc -l)
echo "Total: $N files with mode $MODE"

