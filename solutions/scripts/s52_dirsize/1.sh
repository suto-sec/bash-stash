#!/bin/bash
for d in "$@"; do
  echo "$d: $(ls -A "$d" | wc -l) entries"
done
