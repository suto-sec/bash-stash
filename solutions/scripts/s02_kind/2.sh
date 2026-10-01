#!/bin/bash
p=$1
if [[ -f $p ]]; then
  echo "$p: file"
elif [[ -d $p ]]; then
  echo "$p: directory"
else
  echo "Error: $p not found" >&2
  exit 2
fi
