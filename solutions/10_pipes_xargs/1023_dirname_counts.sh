#!/bin/bash
xargs -d '\n' dirname < paths.txt | sort | uniq -c | sort -k1,1nr -k2 |
  sed -E 's/^ *([0-9]+) (.*)$/\2: \1/'

