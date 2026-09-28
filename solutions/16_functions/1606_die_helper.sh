#!/bin/bash
die() {
  local code=$1; shift
  echo "ERROR: $*" >&2
  exit "$code"
}
[ $# -eq 1 ] || die 1 "usage: $(basename "$0") FILE"
[ -e "$1" ] || die 2 "$1 not found"
[ -r "$1" ] || die 3 "$1 not readable"
wc -w < "$1"

