#!/bin/bash
# miembros.sh GROUPFILE USER...
[ $# -ge 2 ] || { echo "usage: $(basename "$0") GROUPFILE USER..." >&2; exit 1; }
G=$1; shift
[ -f "$G" ] && [ -r "$G" ] || { echo "error: cannot read '$G'" >&2; exit 2; }

N=0; M=0; rc=0
for u in "$@"; do
  if [[ ! $u =~ ^[a-z_][a-z0-9_-]*$ ]]; then
    echo "invalid user name: $u" >&2; rc=3; continue
  fi
  N=$((N + 1)); out=
  while IFS=: read -r name x gid members; do
    IFS=, read -ra mem <<< "$members"
    for m in "${mem[@]}"; do
      if [ "$m" = "$u" ]; then out+=" $name"; break; fi
    done
  done < "$G"
  if [ -z "$out" ]; then echo "$u: -"; M=$((M + 1)); else echo "$u:$out"; fi
done
echo "$N users checked, $M without groups"
exit $rc

