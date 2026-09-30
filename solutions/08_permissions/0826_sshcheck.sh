#!/bin/bash
# sshcheck.sh [-f] - check (and fix) the permissions of ~/.ssh
FIX=0
if [ $# -eq 1 ] && [ "$1" = -f ]; then
  FIX=1
elif [ $# -ne 0 ]; then
  echo "Usage: $(basename "$0") [-f]" >&2
  exit 2
fi
SSH=$HOME/.ssh
[ -d "$SSH" ] || { echo "Error: $SSH is not a directory" >&2; exit 3; }

N=0
# check PATH FORBIDDEN_BITS(octal) FIX_MODE
check() {
  local old new
  old=$(stat -c %a "$1")
  (( 8#$old & 8#$2 )) || return 0
  N=$((N + 1))
  if [ $FIX -eq 1 ]; then
    chmod "$3" "$1"
    new=$(stat -c %a "$1")
    echo "FIXED $1: $old -> $new"
  else
    echo "BAD $1: $old"
  fi
}

check "$HOME" 022 go-w
check "$SSH" 077 go=
[ -e "$SSH/authorized_keys" ] && check "$SSH/authorized_keys" 077 go=
for k in "$SSH"/id_*; do
  [ -f "$k" ] || continue
  [[ $k == *.pub ]] && continue
  check "$k" 077 go=
done
for k in "$SSH"/*.pub; do
  [ -f "$k" ] && check "$k" 022 go-w
done

if [ $FIX -eq 1 ]; then
  echo "$N problems fixed"
else
  echo "$N problems found"
  [ $N -eq 0 ] || exit 1
fi

