#!/bin/bash
if (( $# != 1 )); then
  echo "Error: exactly one file is needed" >&2
  echo "Usage: $0 file" >&2
  exit 1
fi
f=$1
if [[ ! -f $f ]]; then echo "Error: $f is not a regular file" >&2; exit 2; fi
if [[ ! -r $f ]]; then echo "Error: cannot read $f" >&2; exit 3; fi
echo "$f: $(wc -l < "$f")"
