#!/bin/bash
if [ $# -ne 2 ]; then
  echo "Usage: $(basename "$0") <source> <destination>" >&2
  exit 1
fi
if [ ! -e "$1" ]; then
  echo "Error: $1 does not exist" >&2
  exit 2
fi
cp "$1" "$2"
echo "Copied $1 to $2"

