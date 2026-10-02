#!/bin/bash
only=
if [[ $1 == -c ]]; then only=1; shift; fi
if (( $# != 2 )); then echo "Error: two arguments needed" >&2; echo "Usage: $0 [-c] bindir mandir" >&2; exit 1; fi
for d in "$1" "$2"; do [[ -e $d ]] || { echo "Error: $d does not exist" >&2; exit 2; }; done
for d in "$1" "$2"; do [[ -d $d ]] || { echo "Error: $d is not a directory" >&2; exit 3; }; done
n=0
while IFS= read -r f; do
  if [[ ! -e $2/$f.1.gz ]]; then
    n=$((n + 1))
    [[ -n $only ]] || echo "$f"
  fi
done < <(ls "$1")
if [[ -n $only ]]; then echo "$n"; else echo "$n commands without a manual page"; fi
