#!/bin/bash
if (( $# == 0 )); then echo "Error: at least one name is needed" >&2; echo "Usage: $0 \"full name\"..." >&2; exit 1; fi
for name in "$@"; do
  out=
  for w in $name; do out+=${w:0:1}; done
  echo "$name: ${out^^}"
done
