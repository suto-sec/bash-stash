#!/bin/bash
# countext.sh DIR EXT
[ $# -eq 2 ] || { echo "Usage: $(basename "$0") DIR EXT" >&2; exit 1; }
DIR=$1
EXT=$2
[ -d "$DIR" ] || { echo "Error: '$DIR' is not a directory" >&2; exit 2; }
R=$(find "$DIR" -type f -name "*.$EXT" | sort)
[ -n "$R" ] && echo "$R"
N=$(find "$DIR" -type f -name "*.$EXT" | wc -l)
echo "Total: $N files with extension .$EXT"

