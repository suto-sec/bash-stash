#!/bin/bash
find proj \( -name node_modules -o -name .git \) -prune -o -type f -name '*.js' -print | sort
echo ---
find proj -path '*/node_modules/*' -type f -name '*.js' | wc -l

