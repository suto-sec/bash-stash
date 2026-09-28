#!/bin/bash
DIR=${1:-.}
[ -d "$DIR" ] || { echo "Error: $DIR is not a directory" >&2; exit 2; }
FOUND=0
section() { # title, then find arguments
  local title=$1 r; shift
  echo "== $title =="
  r=$(find "$DIR" "$@" | sort)
  if [ -n "$r" ]; then echo "$r"; FOUND=1; else echo "(none)"; fi
}
section "world-writable files" -type f -perm -o+w
section "world-writable dirs without sticky bit" -type d -perm -o+w ! -perm -1000
section "setuid/setgid files" -type f -perm /6000
section "scripts without execute permission" -type f -name '*.sh' ! -perm /111
exit $FOUND

