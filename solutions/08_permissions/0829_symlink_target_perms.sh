#!/bin/bash
for f in enlaces/*; do
  name=$(basename "$f")
  if [ -L "$f" ]; then
    if [ ! -e "$f" ]; then
      echo "$name: broken"
    else
      echo "$name -> $(readlink "$f"): $(stat -c %a "$f")"
    fi
  else
    echo "$name: $(stat -c %a "$f")"
  fi
done

