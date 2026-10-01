#!/bin/bash
if (( $# == 0 )); then echo "Error: no arguments given" >&2; echo "Usage: $0 arg..." >&2; exit 1; fi
i=0
for a in "$@"; do
  i=$((i + 1))
  echo "$i: $a"
done
