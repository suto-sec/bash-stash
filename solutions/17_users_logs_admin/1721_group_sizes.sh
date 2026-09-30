#!/bin/bash
# groupsize.sh [group_file]
[ $# -le 1 ] || { echo "Usage: $(basename "$0") [group_file]" >&2; exit 2; }
GR=${1:-/etc/group}
[ -r "$GR" ] || { echo "Error: cannot read $GR" >&2; exit 1; }

R=$(while IFS=: read -r name x gid members; do
  [ -z "$members" ] && continue
  echo "$name $(echo "$members" | tr , '\n' | wc -l)"
done < "$GR" | sort -k2,2nr -k1,1)

G=0; M=0
if [ -n "$R" ]; then
  echo "$R"
  G=$(echo "$R" | wc -l)
  for n in $(echo "$R" | cut -d' ' -f2); do M=$((M + n)); done
fi
echo "Total: $G groups, $M memberships"

