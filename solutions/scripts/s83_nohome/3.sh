#!/bin/bash
if (( $# != 1 )); then echo "Error: one argument needed" >&2; echo "Usage: $0 passwdfile" >&2; exit 1; fi
[[ -e $1 ]] || { echo "Error: $1 does not exist" >&2; exit 2; }
[[ -f $1 ]] || { echo "Error: $1 is not a regular file" >&2; exit 3; }
while IFS=: read -r user _ _ _ _ home _; do
  if [[ ! -e $home ]]; then echo "$user: missing"
  elif [[ ! -d $home ]]; then echo "$user: not a directory"
  fi
done < "$1"
exit 0
