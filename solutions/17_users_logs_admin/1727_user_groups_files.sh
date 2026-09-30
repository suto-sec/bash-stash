#!/bin/bash
# usergroups.sh USER [passwd_file] [group_file]
[ $# -ge 1 ] && [ $# -le 3 ] || { echo "Usage: $(basename "$0") USER [passwd_file] [group_file]" >&2; exit 2; }
U=$1
PW=${2:-/etc/passwd}
GR=${3:-/etc/group}
for f in "$PW" "$GR"; do
  [ -r "$f" ] || { echo "Error: cannot read $f" >&2; exit 3; }
done
LINE=$(grep "^$U:" "$PW") || { echo "Error: no such user: $U" >&2; exit 1; }
GID=$(echo "$LINE" | cut -d: -f4)

PRIMARY=$GID
SUP=()
while IFS=: read -r name x gid members; do
  if [ "$gid" = "$GID" ]; then
    PRIMARY=$name
  elif echo "$members" | tr , '\n' | grep -qx "$U"; then
    SUP+=("$name")
  fi
done < "$GR"

echo "primary: $PRIMARY"
if [ ${#SUP[@]} -eq 0 ]; then echo "supplementary: (none)"; else echo "supplementary: ${SUP[*]}"; fi
echo "total: $((1 + ${#SUP[@]}))"

