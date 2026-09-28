#!/bin/bash
if [ $# -eq 0 ]; then
  echo "Usage: $(basename "$0") <file>..." >&2
  exit 1
fi
echo "OK: $# files"

