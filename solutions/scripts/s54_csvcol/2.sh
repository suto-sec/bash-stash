#!/bin/bash
if (( $# != 2 )); then echo "Error: a file and a column are needed" >&2; echo "Usage: $0 file N" >&2; exit 1; fi
[[ -f $1 && -r $1 ]] || { echo "Error: cannot read $1" >&2; exit 2; }
[[ $2 =~ ^[1-9][0-9]*$ ]] || { echo "Error: '$2' is not a positive integer" >&2; exit 3; }
cut -d, -f"$2" "$1"
