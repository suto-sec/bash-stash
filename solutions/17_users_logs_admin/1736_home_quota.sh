#!/bin/bash
# cuota.sh LIMIT_KB [passwd_file] - homes over a disk quota
[ $# -ge 1 ] && [ $# -le 2 ] || { echo "Usage: $(basename "$0") LIMIT_KB [passwd_file]" >&2; exit 1; }
LIMIT=$1
PW=${2:-/etc/passwd}
[[ $LIMIT =~ ^[0-9]+$ ]] && [ "$LIMIT" -gt 0 ] || { echo "Error: LIMIT_KB must be a positive integer" >&2; exit 2; }
[ -r "$PW" ] || { echo "Error: cannot read $PW" >&2; exit 3; }

N=0
while IFS=: read -r login x uid gid gecos home shell; do
  [ "$uid" -ge 1000 ] && [ "$uid" -le 59999 ] || continue
  if [ ! -d "$home" ]; then
    echo "$login: no home ($home)"
  elif [ ! -r "$home" ] || [ ! -x "$home" ]; then
    echo "$login: cannot read $home"
  else
    kb=$(du -sk "$home" | cut -f1)
    if [ "$kb" -gt "$LIMIT" ]; then
      echo "$login: $kb KB (over by $((kb - LIMIT)) KB)"
      N=$((N + 1))
    fi
  fi
done < "$PW"
echo "$N users over the limit of $LIMIT KB"
