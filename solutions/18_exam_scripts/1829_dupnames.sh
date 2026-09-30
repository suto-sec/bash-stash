#!/bin/bash
# dupnames.sh DIR1 DIR2
usage() { echo "Usage: $(basename "$0") DIR1 DIR2" >&2; }
[ $# -eq 2 ] || { usage; exit 1; }
D1=$1
D2=$2
[ -d "$D1" ] || { echo "Error: '$D1' is not a directory" >&2; exit 2; }
[ -d "$D2" ] || { echo "Error: '$D2' is not a directory" >&2; exit 3; }
list() { find "$1" -maxdepth 1 -type f ! -name '.*' -printf '%f\n'; }
R=$( { list "$D1"; list "$D2"; } | sort | uniq -d )
[ -n "$R" ] && echo "$R"
N=$(echo "$R" | grep -c .)
echo "Total: $N common names"

