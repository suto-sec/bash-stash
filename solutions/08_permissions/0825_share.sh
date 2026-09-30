#!/bin/bash
# share.sh GROUP DIR - make DIR a shared folder for GROUP (run as root)
[ $# -eq 2 ] || { echo "Usage: $(basename "$0") GROUP DIR" >&2; exit 1; }
G=$1 DIR=$2
line=$(getent group "$G") || { echo "Error: group '$G' does not exist" >&2; exit 2; }
[ -d "$DIR" ] || { echo "Error: '$DIR' is not a directory" >&2; exit 3; }

members=$(echo "$line" | cut -d: -f4)
echo "Members of $G: ${members:-(none)}"

chgrp -R "$G" "$DIR"
nd=$(find "$DIR" -type d | wc -l)
find "$DIR" -type d -exec chmod 2770 {} +
nx=$(find "$DIR" -type f -perm /111 | wc -l)
nf=$(find "$DIR" -type f | wc -l)
find "$DIR" -type f -perm /111 -exec chmod 770 {} +
find "$DIR" -type f ! -perm /111 -exec chmod 660 {} +
echo "Shared $nd directories and $nf files ($nx executable) with $G"

