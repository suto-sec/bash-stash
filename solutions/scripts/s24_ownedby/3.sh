#!/bin/bash
if (( $# != 2 )); then echo "Error: a user and a directory are needed" >&2; echo "Usage: $0 user dir" >&2; exit 1; fi
[[ -e $2 ]] || { echo "Error: $2 does not exist" >&2; exit 2; }
[[ -d $2 ]] || { echo "Error: $2 is not a directory" >&2; exit 3; }
id -u "$1" >/dev/null 2>&1 || { echo "Error: user $1 does not exist" >&2; exit 4; }
find "$2" -type f -user "$1"
