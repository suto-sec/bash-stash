#!/bin/bash
if [ $# -eq 0 ]; then
  echo "Usage: $(basename "$0") HH:MM..." >&2
  exit 2
fi
status=0
for t in "$@"; do
  if [[ $t =~ ^([0-9]{2}):([0-9]{2})$ ]] && [ "${BASH_REMATCH[1]}" -le 23 ] && [ "${BASH_REMATCH[2]}" -le 59 ]; then
    h=$((10#${BASH_REMATCH[1]}))
    m=$((10#${BASH_REMATCH[2]}))
    if [ $h -lt 6 ]; then p=night
    elif [ $h -lt 12 ]; then p=morning
    elif [ $h -lt 20 ]; then p=afternoon
    else p=evening
    fi
    echo "$t $p ($((h * 60 + m)) min)"
  else
    echo "invalid time: $t" >&2
    status=1
  fi
done
exit $status

