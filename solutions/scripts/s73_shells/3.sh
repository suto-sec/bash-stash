#!/bin/bash
only=
if [[ $1 == -u ]]; then only=1; shift; fi
if (( $# != 1 )); then echo "Error: one argument needed" >&2; echo "Usage: $0 [-u] passwdfile" >&2; exit 1; fi
[[ -e $1 ]] || { echo "Error: $1 does not exist" >&2; exit 2; }
[[ -f $1 ]] || { echo "Error: $1 is not a regular file" >&2; exit 3; }
if [[ -n $only ]]; then
  awk -F: '$3 >= 1000 && $3 < 65534 {print $7}' "$1"
else
  cut -d: -f7 "$1"
fi | sort | uniq -c | sort -k1,1nr -k2,2 | while read -r n sh; do echo "$sh: $n"; done
exit 0
