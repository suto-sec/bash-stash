#!/bin/bash
p=$1
if [[ -f $p ]]; then
  echo "$p: file"
elif [[ -d $p ]]; then
  echo "$p: directory"
else
  echo "$p: not found"
fi
