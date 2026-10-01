#!/bin/bash
# expect: 3.5..5
# core logic only: no argument checking at all, no "no files" error
dir=${1:-.}
f=$(ls -t "$dir" | head -1)
echo "$f ($(stat -c %s "$dir/$f") bytes)"
