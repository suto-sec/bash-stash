#!/bin/bash
# nextuid.sh [passwd_file] [MIN]
[ $# -le 2 ] || { echo "Usage: $(basename "$0") [passwd_file] [MIN]" >&2; exit 3; }
PW=${1:-/etc/passwd}
MIN=${2:-1000}
[ -r "$PW" ] || { echo "Error: cannot read $PW" >&2; exit 1; }
[[ $MIN =~ ^[0-9]+$ ]] || { echo "Error: MIN must be a non-negative integer" >&2; exit 2; }

U=$MIN
while cut -d: -f3 "$PW" | grep -qx "$U"; do
  U=$((U + 1))
done
N=0
for uid in $(cut -d: -f3 "$PW"); do
  [ "$uid" -ge "$MIN" ] && N=$((N + 1))
done
echo "Next free UID: $U"
echo "UIDs in use >= $MIN: $N"

