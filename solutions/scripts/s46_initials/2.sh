#!/bin/bash
if (( $# != 1 )); then echo "Error: one name is needed" >&2; echo "Usage: $0 \"full name\"" >&2; exit 1; fi
out=
for w in $1; do
  out+=${w:0:1}
done
echo "${out^^}"
