#!/bin/bash
# tags.sh DIR [TAG] - statistics of the tags of the *.md notes under DIR

if [ $# -lt 1 ] || [ $# -gt 2 ]; then
  echo "Usage: $(basename "$0") DIR [TAG]" >&2
  exit 1
fi
DIR=$1
[ -d "$DIR" ] || { echo "Error: '$DIR' is not a directory" >&2; exit 2; }

if [ $# -eq 1 ]; then
  TAGLINES=$(find "$DIR" -type f -name '*.md' -print0 | xargs -0 -r grep -h '^tags:')
  F=$(echo -n "$TAGLINES" | grep -c '^')
  COUNTS=$(echo "$TAGLINES" | sed 's/^tags://' | tr , '\n' | tr -d ' ' | grep -v '^$' |
           sort | uniq -c | sort -k1,1nr -k2)
  [ -n "$COUNTS" ] && echo "$COUNTS" | sed -E 's/^ *([0-9]+) (.*)$/\2 (\1)/'
  echo "$(echo -n "$COUNTS" | grep -c '^') distinct tags in $F tagged notes"
  exit 0
fi

TAG=$2
[[ $TAG =~ ^[a-z0-9-]+$ ]] || { echo "Error: invalid tag '$TAG'" >&2; exit 3; }
R=$(find "$DIR" -type f -name '*.md' -print0 |
    xargs -0 -r grep -lE -- "^tags:(.*,)? *$TAG *(,|$)" | sort)
[ -n "$R" ] || { echo "No note tagged $TAG" >&2; exit 4; }
echo "$R"
echo "$(echo "$R" | wc -l) notes tagged $TAG"

