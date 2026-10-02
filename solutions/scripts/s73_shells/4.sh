#!/bin/bash
only= want=
while [[ $1 == -u || $1 == -s ]]; do
  if [[ $1 == -u ]]; then only=1; shift
  else
    (( $# >= 2 )) || { echo "Error: -s needs a shell" >&2; echo "Usage: $0 [-u] [-s shell] passwdfile" >&2; exit 1; }
    want=$2; shift 2
  fi
done
if (( $# != 1 )); then echo "Error: one argument needed" >&2; echo "Usage: $0 [-u] [-s shell] passwdfile" >&2; exit 1; fi
[[ -e $1 ]] || { echo "Error: $1 does not exist" >&2; exit 2; }
[[ -f $1 ]] || { echo "Error: $1 is not a regular file" >&2; exit 3; }
if [[ -n $want ]]; then
  awk -F: -v s="$want" -v u="$only" '$7 == s && (u == "" || ($3 >= 1000 && $3 < 65534)) {print $1}' "$1" | { n=0; while read -r name; do echo "$name"; n=$((n + 1)); done; echo "Total: $n"; }
else
  if [[ -n $only ]]; then
    awk -F: '$3 >= 1000 && $3 < 65534 {print $7}' "$1"
  else
    cut -d: -f7 "$1"
  fi | sort | uniq -c | sort -k1,1nr -k2,2 | while read -r n sh; do echo "$sh: $n"; done
fi
exit 0
