#!/bin/bash
# badlinks.sh [-d] DIR - list (and optionally delete) broken symbolic links
usage() { echo "Usage: $(basename "$0") [-d] DIR" >&2; exit 1; }

DEL=0
if [ "$1" = "-d" ]; then
  DEL=1
  shift
fi
[ $# -eq 1 ] || usage
case $1 in -*) usage ;; esac
DIR=$1
[ -d "$DIR" ] || { echo "Error: '$DIR' is not a directory" >&2; exit 2; }

N=0
while IFS= read -r l; do
  t=$(readlink "$l")
  if [ $DEL -eq 1 ]; then
    rm -f "$l"
    echo "deleted $l -> $t"
  else
    echo "$l -> $t"
  fi
  N=$((N + 1))
done < <(find "$DIR" -xtype l | sort)

if [ $DEL -eq 1 ]; then echo "$N broken links deleted"; else echo "$N broken links found"; fi

