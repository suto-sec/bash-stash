#!/bin/bash
find "$1" -type f -print0 | sort -z | xargs -0 md5sum | awk '{h=$1; sub(/^[^ ]+  /, ""); if (seen[h]++) print}' | sort
exit 0
