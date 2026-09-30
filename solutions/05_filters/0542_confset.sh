#!/bin/bash
# confset.sh FILE KEY [VALUE]: read or set KEY=VALUE in a configuration file

if [ $# -ne 2 ] && [ $# -ne 3 ]; then
  echo "Error: wrong number of arguments" >&2
  echo "Usage: $(basename "$0") FILE KEY [VALUE]" >&2
  exit 1
fi
F=$1 K=$2 V=$3
if [ ! -f "$F" ]; then
  echo "Error: '$F' is not a regular file" >&2
  exit 2
fi
if ! [[ $K =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]; then
  echo "Error: invalid key '$K'" >&2
  exit 4
fi

if [ $# -eq 2 ]; then
  line=$(grep -m 1 "^$K=" "$F")
  if [ -z "$line" ]; then
    echo "Error: $K is not set in '$F'" >&2
    exit 3
  fi
  echo "${line#*=}"
  exit 0
fi

# values may contain '/', so use '|' as the sed delimiter
if grep -q "^$K=" "$F"; then
  sed -i "s|^$K=.*|$K=$V|" "$F"; st=updated
elif grep -q "^#$K=" "$F"; then
  sed -i "s|^#$K=.*|$K=$V|" "$F"; st=enabled
else
  echo "$K=$V" >> "$F"; st=added
fi
echo "$K=$V ($st)"

