#!/bin/bash
TEXT=$(cat raw.txt)
printf '%s\n' "$TEXT"
echo "Length: ${#TEXT}"
ONLY=${TEXT//[^\\]/}
echo "Backslashes: ${#ONLY}"

