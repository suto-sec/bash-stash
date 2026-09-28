#!/bin/bash
check() {
  if [ -s "$2" ]; then echo "Target file exists! Exiting!" >&2; exit 1; fi
  if [ ! -e "$1" ]; then echo "Source missing!" >&2; exit 2; fi
}
doit() {
  cp "$1" "$2"
  echo copied
}
[ $# -eq 2 ] || { echo "usage: $(basename "$0") SRC DST" >&2; exit 3; }
check "$1" "$2"
doit "$1" "$2"
exit 0

