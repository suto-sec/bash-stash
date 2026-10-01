#!/bin/bash
order=-n
if [[ $1 == -r ]]; then order=-nr; shift; fi
if (( $# != 1 )); then echo "Error: one file is needed" >&2; echo "Usage: $0 [-r] file" >&2; exit 1; fi
[[ -f $1 && -r $1 ]] || { echo "Error: cannot read $1" >&2; exit 2; }
[[ -s $1 ]] || { echo "Error: $1 is empty" >&2; exit 3; }
sort $order "$1"
echo "min: $(sort -n "$1" | head -n 1)"
echo "max: $(sort -n "$1" | tail -n 1)"
