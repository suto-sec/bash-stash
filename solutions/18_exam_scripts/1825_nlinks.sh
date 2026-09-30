#!/bin/bash
# nlinks.sh [DIR]
[ $# -le 1 ] || { echo "Usage: $(basename "$0") [DIR]" >&2; exit 1; }
DIR=${1:-.}
[ -d "$DIR" ] || { echo "Error: '$DIR' is not a directory" >&2; exit 2; }
R=$(find "$DIR" -type f -links +1 -printf '%p %n\n' | sort)
[ -n "$R" ] && echo "$R"
N=$(find "$DIR" -type f -links +1 | wc -l)
echo "Total: $N files"

