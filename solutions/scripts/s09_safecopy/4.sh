#!/bin/bash
if (( $# != 2 )); then
  echo "Error: two arguments are needed" >&2
  echo "Usage: $0 source dest" >&2
  exit 1
fi
if [[ ! -f $1 ]]; then echo "Error: $1 is not a regular file" >&2; exit 2; fi
dest=$2
if [[ -d $dest ]]; then dest=${dest%/}/$(basename "$1"); fi
if [[ -e $dest ]]; then echo "Error: $dest already exists" >&2; exit 3; fi
cp -- "$1" "$dest"
echo "Copied $1 to $dest"
