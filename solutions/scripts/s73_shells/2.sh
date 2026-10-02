#!/bin/bash
if (( $# != 1 )); then echo "Error: one argument needed" >&2; echo "Usage: $0 passwdfile" >&2; exit 1; fi
[[ -e $1 ]] || { echo "Error: $1 does not exist" >&2; exit 2; }
[[ -f $1 ]] || { echo "Error: $1 is not a regular file" >&2; exit 3; }
cut -d: -f7 "$1" | sort | uniq -c | sort -k1,1nr -k2,2 | while read -r n sh; do echo "$sh: $n"; done
exit 0
