#!/bin/bash
if (( $# != 1 )); then
  echo "Error: exactly one argument is needed" >&2
  echo "Usage: $0 path" >&2
  exit 1
fi
p=$1
if [[ -f $p ]]; then
  echo "$p: file"
elif [[ -d $p ]]; then
  echo "$p: directory"
elif [[ -e $p ]]; then
  echo "$p: other"
  exit 3
else
  echo "Error: $p not found" >&2
  exit 2
fi
