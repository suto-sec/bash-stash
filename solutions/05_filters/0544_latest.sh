#!/bin/bash
# latest.sh LOG LEVEL [N]: newest N entries of a level, newest first

if [ $# -lt 2 ] || [ $# -gt 3 ]; then
  echo "Error: wrong number of arguments" >&2
  echo "Usage: $(basename "$0") LOG LEVEL [N]" >&2
  exit 1
fi
F=$1 L=$2 N=${3:-5}
if [ ! -f "$F" ] || [ ! -r "$F" ]; then
  echo "Error: cannot read '$F'" >&2
  exit 2
fi
case $L in
  INFO|WARN|ERROR) ;;
  *) echo "Error: invalid level '$L' (INFO, WARN or ERROR)" >&2; exit 3 ;;
esac
if ! [[ $N =~ ^[1-9][0-9]*$ ]]; then
  echo "Error: '$N' is not a positive integer" >&2
  exit 4
fi

RE="^[^ ]* [^ ]* $L "                 # the level is the third field
grep -n -- "$RE" "$F" | tail -n "$N" | tac | sed 's/:/: /'
T=$(grep -c -- "$RE" "$F")
S=$(( T < N ? T : N ))
echo "Shown $S of $T $L entries"

