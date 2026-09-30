#!/bin/bash
# homes.sh [passwd_file] - audit home directories of human users
[ $# -le 1 ] || { echo "Usage: $(basename "$0") [passwd_file]" >&2; exit 2; }
PW=${1:-/etc/passwd}
[ -r "$PW" ] || { echo "Error: cannot read $PW" >&2; exit 3; }

N=0; P=0
while IFS=: read -r login x uid gid gecos home shell; do
  [ "$uid" -ge 1000 ] && [ "$uid" -le 59999 ] || continue
  N=$((N + 1))
  if [ ! -e "$home" ]; then
    echo "$login: $home missing"; P=$((P + 1))
  elif [ ! -d "$home" ]; then
    echo "$login: $home is not a directory"; P=$((P + 1))
  elif [ -n "$(find "$home" -maxdepth 0 -perm /007)" ]; then
    echo "$login: $home is open to others ($(stat -c %a "$home"))"; P=$((P + 1))
  fi
done < "$PW"
echo "Checked $N users, $P problems"
[ $P -eq 0 ] || exit 1

