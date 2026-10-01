#!/bin/bash
if (( $# != 2 )); then echo "Error: a file and a user are needed" >&2; echo "Usage: $0 file user" >&2; exit 1; fi
[[ -f $1 && -r $1 ]] || { echo "Error: cannot read $1" >&2; exit 2; }
line=$(grep "^$2:" "$1")
[[ -n $line ]] || { echo "Error: user $2 not found" >&2; exit 3; }
uid=$(echo "$line" | cut -d: -f3)
shell=$(echo "$line" | cut -d: -f7)
echo "$2: uid=$uid shell=$shell"
