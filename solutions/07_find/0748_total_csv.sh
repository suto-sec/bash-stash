#!/bin/bash
DIR=${1:-.}
LAST=$(find "$DIR" -type f -name '*.csv' -exec wc -l {} + 2>/dev/null | tail -n1)
if [[ -z $LAST ]]; then
  echo 0
else
  read -r n _ <<< "$LAST"
  echo "$n"
fi

