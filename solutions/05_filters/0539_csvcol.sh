#!/bin/bash
# csvcol.sh FILE COLUMN: prints the values of a CSV column chosen by its header name

if [ $# -ne 2 ]; then
  echo "Error: wrong number of arguments" >&2
  echo "Usage: $(basename "$0") FILE COLUMN" >&2
  exit 1
fi
F=$1 C=$2
if [ ! -f "$F" ] || [ ! -r "$F" ]; then
  echo "Error: cannot read '$F'" >&2
  exit 2
fi

# position of the column: one header name per line, grep -n gives its number
n=$(head -n 1 "$F" | tr ',' '\n' | grep -nxF -- "$C" | head -n 1 | cut -d: -f1)
if [ -z "$n" ]; then
  echo "Error: there is no column '$C' in '$F'" >&2
  exit 3
fi

values() { tail -n +2 "$F" | cut -d, -f"$n"; }

values | sed 's/^$/(empty)/'
N=$(values | wc -l)
D=$(values | grep -v '^$' | sort -u | wc -l)
E=$(values | grep -c '^$')
echo "$N values, $D distinct, $E empty"

