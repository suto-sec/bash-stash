#!/bin/bash
if (( $# != 1 )); then
  echo "Error: exactly one text is needed" >&2
  echo "Usage: $0 text" >&2
  exit 1
fi
echo "$1" | tr -cd 'aeiouAEIOU' | wc -c
