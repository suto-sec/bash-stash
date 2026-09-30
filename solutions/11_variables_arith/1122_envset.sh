#!/bin/bash
usage() { echo "Usage: $(basename "$0") CONFIGFILE [PREFIX]" >&2; exit 1; }
[ $# -ge 1 ] && [ $# -le 2 ] || usage
CFG=$1
PREFIX=${2:-}
[ -r "$CFG" ] || { echo "Error: cannot read $CFG" >&2; exit 2; }
if [ -n "$PREFIX" ]; then
  [[ $PREFIX =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]] || { echo "Error: invalid PREFIX '$PREFIX'" >&2; exit 3; }
fi

declare -a KEYS
BAD=0 LN=0
while IFS= read -r line; do
  LN=$((LN + 1))
  [[ -z ${line// /} ]] && continue
  [[ $line =~ ^[[:space:]]*# ]] && continue
  if [[ $line == *=* ]]; then
    key=${line%%=*}
    val=${line#*=}
    if [[ $key =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]; then
      if [ -z "$PREFIX" ] || [[ $key == "$PREFIX"* ]]; then
        export "$key=$val"
        KEYS+=("$key")
      fi
      continue
    fi
  fi
  echo "Invalid line $LN: $line" >&2
  BAD=1
done < "$CFG"

mapfile -t SORTED < <(printf '%s\n' "${KEYS[@]}" | sort -u)
for k in "${SORTED[@]}"; do
  echo "$k=${!k}"
done
echo "Exported ${#SORTED[@]} variables"
[ $BAD -eq 1 ] && exit 4
exit 0

