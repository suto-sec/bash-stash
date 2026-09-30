#!/bin/bash
# emptyfiles.sh [DIR]
[ $# -le 1 ] || { echo "Usage: $(basename "$0") [DIR]" >&2; exit 1; }
DIR=${1:-.}
[ -d "$DIR" ] || { echo "Error: '$DIR' is not a directory" >&2; exit 2; }
R=$(find "$DIR" -type f -empty | sort)
[ -n "$R" ] && echo "$R"
N=$(find "$DIR" -type f -empty | wc -l)
echo "Total: $N empty files"

