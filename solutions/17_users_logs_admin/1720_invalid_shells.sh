#!/bin/bash
# badshell.sh [passwd_file] [shells_file]
[ $# -le 2 ] || { echo "Usage: $(basename "$0") [passwd_file] [shells_file]" >&2; exit 2; }
PW=${1:-/etc/passwd}
SH=${2:-/etc/shells}
for f in "$PW" "$SH"; do
  [ -r "$f" ] || { echo "Error: cannot read $f" >&2; exit 1; }
done

N=0
while IFS=: read -r login x uid gid gecos home shell; do
  case $shell in
    */nologin|*/false) continue ;;
  esac
  if ! grep -v '^#' "$SH" | grep -qxF -- "$shell"; then
    echo "$login: $shell"
    N=$((N + 1))
  fi
done < "$PW"
echo "$N users with an invalid shell"

