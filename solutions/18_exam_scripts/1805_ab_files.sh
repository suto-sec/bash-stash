#!/bin/bash
DIR=${1:-.}
[ -d "$DIR" ] || { echo "Error: $DIR is not a directory" >&2; exit 1; }
R=$(find "$DIR" -mindepth 1 \( -name 'a*' -o -name 'b*' \) ! -name '*~*' | sort)
[ -n "$R" ] && echo "$R"
echo "$(echo -n "$R" | grep -c '^') entries"

