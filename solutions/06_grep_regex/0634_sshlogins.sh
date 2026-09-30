#!/bin/bash
# sshlogins.sh LOG [METHOD]
if [ $# -lt 1 ] || [ $# -gt 2 ]; then
  echo "Usage: $(basename "$0") LOG [password|publickey|all]" >&2
  exit 1
fi
LOG=$1
M=${2:-all}
if [ ! -r "$LOG" ]; then
  echo "Error: cannot read '$LOG'" >&2
  exit 2
fi
case $M in
  password|publickey) RE=$M ;;
  all) RE='password|publickey' ;;
  *) echo "Error: invalid method '$M'" >&2; exit 3 ;;
esac

L=$(grep -E "sshd\[[0-9]+\]: Accepted ($RE) for [^ ]+ from [0-9.]+ port " "$LOG" |
    sed -E 's/.*sshd\[[0-9]+\]: Accepted [a-z]+ for ([^ ]+) from ([0-9.]+) port .*/\1 \2/')
N=$(grep -c . <<< "$L")
P=$(sort -u <<< "$L" | grep -c .)
U=$(cut -d' ' -f1 <<< "$L" | sort -u | grep -c .)
[ -n "$L" ] && sort -u <<< "$L"
echo "$N logins, $P distinct pairs, $U users"
[ "$N" -gt 0 ] || exit 4

