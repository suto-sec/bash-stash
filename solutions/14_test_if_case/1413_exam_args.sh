#!/bin/bash
if [ $# -gt 1 ]; then
  echo "Error: too many arguments. Usage: $(basename "$0") [directory]" >&2
  exit 1
fi
DIR=${1:-.}
if [ ! -e "$DIR" ]; then
  echo "Error: '$DIR' does not exist" >&2
  exit 2
fi
if [ ! -d "$DIR" ]; then
  echo "Error: '$DIR' is not a directory" >&2
  exit 3
fi
echo "Base directory: $DIR"

