#!/bin/bash
# newer_than.sh DIR REFFILE
usage() { echo "Usage: $(basename "$0") DIR REFFILE" >&2; }
[ $# -eq 2 ] || { usage; exit 1; }
DIR=$1
REF=$2
[ -d "$DIR" ] || { echo "Error: '$DIR' is not a directory" >&2; exit 2; }
[ -e "$REF" ] || { echo "Error: '$REF' does not exist" >&2; exit 3; }
R=$(find "$DIR" -type f -newer "$REF" | sort)
[ -n "$R" ] && echo "$R"
N=$(find "$DIR" -type f -newer "$REF" | wc -l)
echo "Total: $N files"

