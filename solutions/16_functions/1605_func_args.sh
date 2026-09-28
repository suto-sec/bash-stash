#!/bin/bash
info() { echo "func got $# args: $*"; }
echo "script got $# args: $*"
info
rev=()
for a in "$@"; do rev=("$a" "${rev[@]}"); done
info "${rev[@]}"
info "$@"
info "$*"

