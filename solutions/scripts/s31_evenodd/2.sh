#!/bin/bash
if (( $# != 1 )); then echo "Error: one number is needed" >&2; echo "Usage: $0 N" >&2; exit 1; fi
[[ $1 =~ ^[0-9]+$ ]] || { echo "Error: '$1' is not a non-negative integer" >&2; exit 2; }
if (( $1 % 2 == 0 )); then echo "$1 is even"; else echo "$1 is odd"; fi
