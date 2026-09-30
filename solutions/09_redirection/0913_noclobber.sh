#!/bin/bash
set -o noclobber
while IFS= read -r f; do
  # the group's stderr is redirected before the inner "> $f" is attempted
  if { echo generated > "$f"; } 2>/dev/null; then
    echo "$f: created"
  else
    echo "$f: kept"
  fi
done < lista.txt
echo forced >| forzar.txt
echo forced

