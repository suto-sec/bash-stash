#!/bin/bash
who=
if [[ $1 == -u ]]; then
  (( $# >= 2 )) || { echo "Error: -u needs a user" >&2; echo "Usage: $0 [-u user] group file" >&2; exit 1; }
  who=$2; shift 2
fi
if (( $# != 2 )); then echo "Error: two arguments needed" >&2; echo "Usage: $0 [-u user] group file" >&2; exit 1; fi
[[ -e $2 ]] || { echo "Error: $2 does not exist" >&2; exit 2; }
[[ -f $2 ]] || { echo "Error: $2 is not a regular file" >&2; exit 3; }
line=$(grep "^$1:" "$2") || { echo "Error: group $1 not found in $2" >&2; exit 4; }
if [[ -n $who ]]; then
  if echo "$line" | cut -d: -f4 | tr ',' '\n' | grep -qx -- "$who"; then echo "$who is a member of $1"; exit 0; fi
  echo "$who is not a member of $1"; exit 5
fi
echo "Group $1 (gid $(echo "$line" | cut -d: -f3))"
n=0
while IFS= read -r m; do echo "$m"; n=$((n + 1)); done < <(echo "$line" | cut -d: -f4 | tr ',' '\n' | grep .)
if (( n == 0 )); then echo "No members"; else echo "$n members"; fi
