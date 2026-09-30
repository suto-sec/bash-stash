#!/bin/bash
fixed=0 removed=0
for l in links/*; do
  [ -L "$l" ] && [ ! -e "$l" ] || continue     # only broken links
  name=$(basename "$l")
  t=$(basename "$(readlink "$l")")
  if [ -e "repuesto/$t" ]; then
    ln -sf "../repuesto/$t" "$l"
    echo "fixed $name -> ../repuesto/$t"
    fixed=$((fixed + 1))
  else
    rm "$l"
    echo "removed $name"
    removed=$((removed + 1))
  fi
done
echo "$fixed fixed, $removed removed"

