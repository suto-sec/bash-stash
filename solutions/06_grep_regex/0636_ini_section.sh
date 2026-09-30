#!/bin/bash
# ini.sh FILE SECTION
if [ $# -ne 2 ]; then
  echo "Usage: $(basename "$0") FILE SECTION" >&2
  exit 1
fi
F=$1
S=$2
if [ ! -f "$F" ] || [ ! -r "$F" ]; then
  echo "Error: cannot read '$F'" >&2
  exit 2
fi
# -F: the section name is literal text; -x: whole line
START=$(grep -nxF -- "[$S]" "$F" | head -n 1 | cut -d: -f1)
if [ -z "$START" ]; then
  echo "Error: section '$S' not found" >&2
  exit 3
fi
R=$(tail -n +"$((START + 1))" "$F" | sed '/^\[/,$d' | grep -vE '^[[:space:]]*([#;]|$)' | grep '=' |
    sed -E 's/[[:space:]]*=[[:space:]]*/=/; s/^[[:space:]]+//; s/[[:space:]]+$//')
[ -n "$R" ] && echo "$R"
echo "$(grep -c . <<< "$R") keys in [$S]"

