#!/bin/bash
rev=
if [[ $1 == -r ]]; then rev=1; shift; fi
if (( $# == 0 )); then echo "Error: no arguments given" >&2; echo "Usage: $0 [-r] arg..." >&2; exit 1; fi
if [[ -n $rev ]]; then
  for ((i = $#; i >= 1; i--)); do echo "$i: ${!i}"; done
else
  i=0
  for a in "$@"; do i=$((i + 1)); echo "$i: $a"; done
fi
