#!/bin/bash
# checkips.sh FILE
if [ $# -ne 1 ]; then
  echo "Usage: $(basename "$0") FILE" >&2
  exit 1
fi
F=$1
if [ ! -f "$F" ] || [ ! -r "$F" ]; then
  echo "Error: cannot read '$F'" >&2
  exit 2
fi
N='(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])'
IP="($N\.){3}$N"
grep -nxE "$IP" "$F" | sed 's/:/: /'
V=$(grep -cxE "$IP" "$F")
T=$(grep -c . "$F")
echo "Valid: $V, invalid: $((T - V))"
[ "$V" -gt 0 ] || exit 3

