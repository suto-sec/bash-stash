#!/bin/bash
skip= uniq=
while [[ $1 == -* ]]; do
  case $1 in
    -h) skip=1; shift ;;
    -u) uniq=1; shift ;;
    *) echo "Error: unknown option '$1'" >&2; exit 4 ;;
  esac
done
if (( $# != 2 )); then echo "Error: a file and a column are needed" >&2; echo "Usage: $0 [-h] [-u] file N" >&2; exit 1; fi
[[ -f $1 && -r $1 ]] || { echo "Error: cannot read $1" >&2; exit 2; }
[[ $2 =~ ^[1-9][0-9]*$ ]] || { echo "Error: '$2' is not a positive integer" >&2; exit 3; }
if [[ -n $skip ]]; then body=$(tail -n +2 "$1"); else body=$(cat "$1"); fi
if [[ -n $body ]]; then
  if [[ -n $uniq ]]; then echo "$body" | cut -d, -f"$2" | sort -u; else echo "$body" | cut -d, -f"$2"; fi
fi
exit 0
