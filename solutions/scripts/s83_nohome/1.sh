#!/bin/bash
while IFS=: read -r user _ _ _ _ home _; do
  [[ -e $home ]] || echo "$user"
done < "$1"
exit 0
