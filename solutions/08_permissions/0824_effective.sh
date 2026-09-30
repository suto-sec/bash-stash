#!/bin/bash
# effective.sh USER FILE... - effective permissions of USER on each FILE
[ $# -ge 2 ] || { echo "Usage: $(basename "$0") USER FILE..." >&2; exit 1; }
U=$1; shift
id "$U" > /dev/null 2>&1 || { echo "Error: user '$U' does not exist" >&2; exit 2; }
[ "$(id -u "$U")" -eq 0 ] && { echo "Error: root bypasses permissions" >&2; exit 3; }
GROUPS_OF_U=" $(id -Gn "$U") "

n=0 missing=0
for f in "$@"; do
  if [ ! -e "$f" ]; then
    echo "Error: '$f' does not exist" >&2
    missing=1
    continue
  fi
  owner=$(stat -c %U "$f") group=$(stat -c %G "$f") perm=$(stat -c %A "$f")
  if [ "$owner" = "$U" ]; then
    echo "$f: ${perm:1:3} (owner)"
  elif [[ $GROUPS_OF_U == *" $group "* ]]; then
    echo "$f: ${perm:4:3} (group)"
  else
    echo "$f: ${perm:7:3} (other)"
  fi
  n=$((n + 1))
done
echo "$n files checked"
[ $missing -eq 0 ] || exit 4

