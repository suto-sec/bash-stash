#!/bin/bash
DIR=${1:-.}
[ -d "$DIR" ] || { echo "Error: $DIR is not a directory" >&2; exit 2; }
R=$(find "$DIR" -type f -exec stat -c '%s %n' {} + | sort -k1,1nr -k2 | head -n 2)
[ -z "$R" ] && { echo "No files"; exit 1; }
echo "$R"

