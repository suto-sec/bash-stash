#!/bin/bash
find docs -type f -print0 | sort -z | while IFS= read -r -d '' f; do
  echo "$f ($(stat -c %s "$f") bytes)"
done

