#!/bin/bash
# altas.sh FILE - create users from "login:Full Name:groups" lines (run as root)
[ $# -eq 1 ] || { echo "Usage: $(basename "$0") FILE" >&2; exit 1; }
F=$1
[ -f "$F" ] && [ -r "$F" ] || { echo "Error: cannot read $F" >&2; exit 2; }

N=0; M=0
while IFS=: read -r login name groups; do
  [ -z "$login" ] && continue
  [[ $login == '#'* ]] && continue
  if id "$login" > /dev/null 2>&1; then
    echo "skip $login: already exists" >&2
    M=$((M + 1))
    continue
  fi
  for g in $(echo "$groups" | tr , ' '); do
    if ! getent group "$g" > /dev/null; then
      groupadd "$g" && echo "group $g created"
    fi
  done
  if [ -n "$groups" ]; then
    useradd -m -s /bin/bash -c "$name" -G "$groups" "$login"
  else
    useradd -m -s /bin/bash -c "$name" "$login"
  fi && echo "user $login created" && N=$((N + 1))
done < "$F"

echo "Created $N users, skipped $M"
[ $M -eq 0 ] || exit 3

