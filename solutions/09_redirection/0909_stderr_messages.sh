#!/bin/bash
if [ -f "$1" ]; then
  wc -l < "$1"
else
  echo "Error: $1 not found" >&2
  exit 1
fi

