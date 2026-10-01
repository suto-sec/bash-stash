#!/bin/bash
if (( $# != 1 )); then echo "Error: one number of days is needed" >&2; echo "Usage: $0 days" >&2; exit 1; fi
[[ $1 =~ ^[0-9]+$ ]] || { echo "Error: '$1' is not a number of days" >&2; exit 2; }
find . -type f -mtime +"$1"
