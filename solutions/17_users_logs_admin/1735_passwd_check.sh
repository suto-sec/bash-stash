#!/bin/bash
# pwcheck.sh [passwd_file] [group_file] - consistency checks on a passwd file
[ $# -le 2 ] || { echo "Usage: $(basename "$0") [passwd_file] [group_file]" >&2; exit 2; }
PW=${1:-/etc/passwd}
GR=${2:-/etc/group}
for f in "$PW" "$GR"; do
  [ -r "$f" ] || { echo "Error: cannot read $f" >&2; exit 3; }
done

n=0; P=0
LOGINS=; UIDS=     # values seen on earlier valid lines, one per line
while IFS= read -r line; do
  n=$((n + 1))
  f=$(( $(echo -n "$line" | tr -cd : | wc -c) + 1 ))
  if [ $f -ne 7 ]; then
    echo "line $n: wrong number of fields ($f)"; P=$((P + 1)); continue
  fi
  login=$(echo "$line" | cut -d: -f1)
  uid=$(echo "$line" | cut -d: -f3)
  gid=$(echo "$line" | cut -d: -f4)
  if echo "$LOGINS" | grep -qxF -- "$login"; then
    echo "line $n: duplicate login $login"; P=$((P + 1))
  fi
  if echo "$UIDS" | grep -qxF -- "$uid"; then
    echo "line $n: duplicate UID $uid ($login)"; P=$((P + 1))
  fi
  if ! cut -d: -f3 "$GR" | grep -qxF -- "$gid"; then
    echo "line $n: unknown GID $gid ($login)"; P=$((P + 1))
  fi
  LOGINS+="$login"$'\n'
  UIDS+="$uid"$'\n'
done < "$PW"

if [ $P -eq 0 ]; then
  echo "$PW: OK"
else
  echo "$P problems in $PW"
  exit 1
fi

