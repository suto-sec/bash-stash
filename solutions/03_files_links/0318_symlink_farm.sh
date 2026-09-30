#!/bin/bash
mkdir bin
for f in scripts/*.sh; do
  [ -f "$f" ] || continue
  name=$(basename "$f" .sh)
  ln -s "../scripts/$name.sh" "bin/$name"
done
for l in bin/*; do
  echo "$(basename "$l") -> $(readlink "$l")"
done

