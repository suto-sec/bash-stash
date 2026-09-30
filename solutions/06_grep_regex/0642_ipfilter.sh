#!/bin/bash
# ipfilter.sh FILE PREFIX: lines with an IPv4 address starting with PREFIX

if [ $# -ne 2 ]; then
  echo "Error: wrong number of arguments" >&2
  echo "Usage: $(basename "$0") FILE PREFIX" >&2
  exit 1
fi
F=$1 P=$2
if [ ! -f "$F" ] || [ ! -r "$F" ]; then
  echo "Error: cannot read '$F'" >&2
  exit 2
fi
if ! [[ $P =~ ^[0-9]{1,3}(\.[0-9]{1,3}){0,2}\.?$ ]]; then
  echo "Error: '$P' is not a valid IPv4 prefix" >&2
  exit 3
fi

ESCAPED=$(printf '%s' "$P" | sed 's/\./\\./g')
grep -E "(^|[^0-9.])${ESCAPED}[0-9]" -- "$F"

