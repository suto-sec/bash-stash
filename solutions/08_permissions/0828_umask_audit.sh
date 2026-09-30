#!/bin/bash
# umask_audit.sh [-f] UMASK DIR - find (and fix) entries more open than a umask
usage() { echo "Usage: $(basename "$0") [-f] UMASK DIR" >&2; exit 1; }
FIX=0
if [ "$1" = -f ]; then FIX=1; shift; fi
[ $# -eq 2 ] || usage
[[ $1 == -* ]] && usage
U=$1 DIR=$2
[ -d "$DIR" ] || { echo "Error: '$DIR' is not a directory" >&2; exit 2; }
[[ $U =~ ^0?0[0-7][0-7]$ ]] || { echo "Error: '$U' is not a valid umask" >&2; exit 3; }

n=0 total=0
# sort reads all of find's output before printing anything, so the chmods below
# cannot disturb the traversal
while IFS= read -r p; do
  total=$((total + 1))
  mode=$(( 8#$(stat -c %a "$p") ))
  extra=$(( mode & 8#$U ))
  (( extra )) || continue
  n=$((n + 1))
  if [ $FIX -eq 1 ]; then
    new=$(printf '%03o' $(( mode & ~8#$U )))
    chmod "$new" "$p"
    printf '%s: %03o -> %s\n' "$p" "$mode" "$new"
  else
    printf '%s: %03o (extra %03o)\n' "$p" "$mode" "$extra"
  fi
done < <(find "$DIR" -mindepth 1 \( -type f -o -type d \) | sort)
echo "$n of $total entries exceed umask $U"
