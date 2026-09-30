#!/bin/bash
echo "proj: $(find proj -type f | wc -l) files, $(find proj -mindepth 1 -type d | wc -l) directories, $(find proj -type f -print0 | xargs -0 cat | wc -c) bytes, largest: $(find proj -type f -printf '%s %p\n' | sort -nr | head -n 1 | cut -d' ' -f2-)"

