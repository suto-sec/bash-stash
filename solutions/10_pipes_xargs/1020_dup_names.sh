#!/bin/bash
find tree -type f | sed 's#.*/##' | sort | uniq -c | grep -v '^ *1 ' |
  sed -E 's/^ *([0-9]+) (.*)$/\2: \1 copies/'
echo "$(find tree -type f | sed 's#.*/##' | sort | uniq -d | wc -l) repeated names"

