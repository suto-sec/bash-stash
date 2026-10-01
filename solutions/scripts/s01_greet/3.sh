#!/bin/bash
if (( $# > 1 )); then
  echo "Error: too many arguments" >&2
  echo "Usage: $0 [name]" >&2
  exit 1
fi
if [[ -n $1 ]]; then
  echo "Hello, $1!"
else
  echo "Hello, world!"
fi
