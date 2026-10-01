#!/bin/bash
if (( $# != 1 )); then echo "Error: one log file is needed" >&2; echo "Usage: $0 file" >&2; exit 1; fi
[[ -f $1 && -r $1 ]] || { echo "Error: cannot read $1" >&2; exit 2; }
for level in INFO WARN ERROR; do
  echo "$level: $(grep -c " $level " "$1")"
done
