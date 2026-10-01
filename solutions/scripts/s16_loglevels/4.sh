#!/bin/bash
level=
if [[ $1 == -l ]]; then
  if (( $# != 3 )); then echo "Error: -l needs a level and a file" >&2; echo "Usage: $0 [-l LEVEL] file" >&2; exit 1; fi
  level=$2; shift 2
fi
if (( $# != 1 )); then echo "Error: one log file is needed" >&2; echo "Usage: $0 [-l LEVEL] file" >&2; exit 1; fi
[[ -f $1 && -r $1 ]] || { echo "Error: cannot read $1" >&2; exit 2; }
if [[ -n $level ]]; then
  case $level in INFO|WARN|ERROR) ;; *) echo "Error: unknown level '$level'" >&2; exit 3 ;; esac
  grep " $level " "$1"
  exit 0
fi
for l in INFO WARN ERROR; do
  echo "$l: $(grep -c " $l " "$1")"
done
