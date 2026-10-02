#!/bin/bash
while IFS= read -r f; do
  [[ -e $2/$f.1.gz ]] || echo "$f"
done < <(ls "$1")
