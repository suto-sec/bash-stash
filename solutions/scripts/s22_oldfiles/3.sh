#!/bin/bash
if (( $# < 1 || $# > 2 )); then echo "Error: wrong number of arguments" >&2; echo "Usage: $0 days [dir]" >&2; exit 1; fi
[[ $1 =~ ^[0-9]+$ ]] || { echo "Error: '$1' is not a number of days" >&2; exit 2; }
dir=${2:-.}
[[ -d $dir ]] || { echo "Error: $dir is not a directory" >&2; exit 3; }
find "$dir" -type f -mtime +"$1"
