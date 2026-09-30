#!/bin/bash
v=0 i=0
for a in "$@"; do
  if [[ $a =~ ^([A-Za-z0-9-]+)_([0-9]{4})-([0-9]{2})-([0-9]{2})\.(tar\.gz|tgz)$ ]] &&
     [ "${BASH_REMATCH[3]}" -ge 1 ] && [ "${BASH_REMATCH[3]}" -le 12 ] &&
     [ "${BASH_REMATCH[4]}" -ge 1 ] && [ "${BASH_REMATCH[4]}" -le 31 ]; then
    echo "${BASH_REMATCH[1]}: ${BASH_REMATCH[4]}/${BASH_REMATCH[3]}/${BASH_REMATCH[2]} (${BASH_REMATCH[5]})"
    v=$((v + 1))
  else
    echo "invalid: $a"
    i=$((i + 1))
  fi
done
echo "$v valid, $i invalid"

