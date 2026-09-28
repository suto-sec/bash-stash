#!/bin/bash
PW=${1:-/etc/passwd}
GR=${2:-/etc/group}
for f in "$PW" "$GR"; do [ -r "$f" ] || { echo "Error: cannot read $f" >&2; exit 1; }; done
N=0
while IFS=: read -r login x uid gid gecos home shell; do
  [ "$uid" -ge 1000 ] && [ "$uid" -lt 60000 ] || continue
  if [ -d "$home" ]; then h=exists; else h=missing; fi
  g=$(cut -d: -f4 "$GR" | tr , '\n' | grep -cx "$login")
  echo "$login uid=$uid home=$home ($h) shell=$shell groups=$((g + 1))"
  N=$((N + 1))
done < "$PW"
echo "Total: $N users"

