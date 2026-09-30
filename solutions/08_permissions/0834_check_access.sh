#!/bin/bash
if [ $# -ne 2 ]; then
  echo "Usage: $(basename "$0") USER FILE" >&2
  exit 1
fi
U=$1
F=$2
id "$U" > /dev/null 2>&1 || { echo "Error: user '$U' does not exist" >&2; exit 2; }
[ -e "$F" ] || { echo "Error: '$F' does not exist" >&2; exit 3; }

r=no; w=no; x=no
sudo -u "$U" -- test -r "$F" && r=yes
sudo -u "$U" -- test -w "$F" && w=yes
sudo -u "$U" -- test -x "$F" && x=yes
echo "read:$r write:$w exec:$x"
