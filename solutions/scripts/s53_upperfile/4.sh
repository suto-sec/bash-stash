#!/bin/bash
force=
if [[ $1 == -f ]]; then force=1; shift; fi
if (( $# != 1 )); then echo "Error: one file is needed" >&2; echo "Usage: $0 [-f] file" >&2; exit 1; fi
[[ -f $1 && -r $1 ]] || { echo "Error: cannot read $1" >&2; exit 2; }
verb=Created
if [[ -e $1.upper ]]; then
  [[ -n $force ]] || { echo "Error: $1.upper already exists" >&2; exit 3; }
  verb=Replaced
fi
tr a-z A-Z < "$1" > "$1.upper"
echo "$verb $1.upper"
