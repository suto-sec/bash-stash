#!/bin/bash
for f in datos/*; do
  [ "$f" = datos/master ] && continue
  [ -L "$f" ] && continue                 # -ef follows symbolic links: exclude them
  [ "$f" -ef datos/master ] && basename "$f"
done
echo "links: $(stat -c %h datos/master)"

