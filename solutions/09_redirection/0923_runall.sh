#!/bin/bash
# runall.sh DIR [LOGDIR]
if [ $# -lt 1 ] || [ $# -gt 2 ]; then
  echo "Usage: $(basename "$0") DIR [LOGDIR]" >&2
  exit 1
fi
DIR=$1
LOGDIR=${2:-$DIR/logs}
if [ ! -d "$DIR" ]; then
  echo "Error: '$DIR' is not a directory" >&2
  exit 2
fi
if [ -e "$LOGDIR" ] && [ ! -d "$LOGDIR" ]; then
  echo "Error: '$LOGDIR' is not a directory" >&2
  exit 3
fi
mkdir -p "$LOGDIR"

N=0 F=0
for f in "$DIR"/*.sh; do
  [ -f "$f" ] && [ -x "$f" ] || continue
  name=$(basename "$f" .sh)
  "$f" < /dev/null > "$LOGDIR/$name.out" 2> "$LOGDIR/$name.err"
  code=$?
  o=$(wc -l < "$LOGDIR/$name.out")
  e=$(wc -l < "$LOGDIR/$name.err")
  [ -s "$LOGDIR/$name.err" ] || rm "$LOGDIR/$name.err"
  echo "$name: exit $code, $o out, $e err"
  N=$((N + 1))
  [ $code -ne 0 ] && F=$((F + 1))
done
echo "$N scripts, $F failed"
[ $F -eq 0 ] || exit 5

