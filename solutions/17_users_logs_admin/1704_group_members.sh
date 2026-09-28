#!/bin/bash
line=$(grep "^$1:" /etc/group) || { echo "no such group: $1" >&2; exit 1; }
gid=$(echo "$line" | cut -d: -f3)
{
  echo "$line" | cut -d: -f4 | tr , '\n'
  while IFS=: read -r u x uid g rest; do [ "$g" = "$gid" ] && echo "$u"; done < /etc/passwd
} | grep -v '^$' | sort -u

