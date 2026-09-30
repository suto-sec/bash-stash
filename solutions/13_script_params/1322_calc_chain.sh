#!/bin/bash
# calc.sh n1 [op n2]... - left-to-right integer calculator

usage() {
  echo "Usage: $(basename "$0") n1 [op n2]..." >&2
  exit 1
}

# an odd number of arguments (at least 1) is required
if [ $# -eq 0 ] || (( $# % 2 == 0 )); then
  usage
fi

# validate everything first, from left to right
i=1
prev=
for a in "$@"; do
  if (( i % 2 == 1 )); then            # operand
    if [[ ! $a =~ ^-?(0|[1-9][0-9]*)$ ]]; then
      echo "Error: '$a' is not a valid integer" >&2
      exit 2
    fi
    if [[ $prev == / || $prev == % ]] && (( a == 0 )); then
      echo "Error: division by zero ($prev $a)" >&2
      exit 4
    fi
  else                                 # operator
    case $a in
      + | - | x | / | %) ;;
      *) echo "Error: unknown operator '$a'" >&2; exit 3 ;;
    esac
  fi
  prev=$a
  i=$((i + 1))
done

r=$1
shift
while [ $# -gt 0 ]; do
  op=$1 b=$2
  case $op in
    +) n=$((r + b)) ;;
    -) n=$((r - b)) ;;
    x) n=$((r * b)) ;;
    /) n=$((r / b)) ;;
    %) n=$((r % b)) ;;
  esac
  echo "$r $op $b = $n"
  r=$n
  shift 2
done
echo "Result: $r"

