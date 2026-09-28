#!/bin/bash
[ $# -eq 0 ] && exit 0
echo "== $1 =="
shift
for i in "$@"; do echo "- $i"; done
echo "($# items)"

