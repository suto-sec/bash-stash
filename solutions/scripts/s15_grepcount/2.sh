#!/bin/bash
if (( $# < 2 )); then echo "Error: a word and a file are needed" >&2; echo "Usage: $0 word file..." >&2; exit 1; fi
word=$1; shift
for f in "$@"; do
  echo "$f: $(grep -c -- "$word" "$f")"
done
