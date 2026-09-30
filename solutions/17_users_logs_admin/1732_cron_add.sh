#!/bin/bash
# cronadd.sh "SCHEDULE" "COMMAND" - add a validated job to my crontab
[ $# -eq 2 ] || { echo "Usage: $(basename "$0") \"SCHEDULE\" \"COMMAND\"" >&2; exit 1; }
S=$1
F='(\*|[0-9]+|\*/[0-9]+)'
[[ $S =~ ^$F( $F){4}$ ]] || { echo "Error: invalid schedule '$S'" >&2; exit 2; }

in_range() { # field min max
  case $1 in
    '*') return 0 ;;
    '*/'*) [ $((10#${1#*/})) -ge 1 ] ;;
    *) [ $((10#$1)) -ge "$2" ] && [ $((10#$1)) -le "$3" ] ;;
  esac
}
read -r mi ho dm mo dw <<< "$S"
if ! in_range "$mi" 0 59 || ! in_range "$ho" 0 23 || ! in_range "$dm" 1 31 ||
   ! in_range "$mo" 1 12 || ! in_range "$dw" 0 7; then
  echo "Error: value out of range in '$S'" >&2; exit 3
fi

JOB="$S $2"
CUR=$(crontab -l 2>/dev/null)
if echo "$CUR" | grep -qxF -- "$JOB"; then
  echo "Already scheduled: $JOB"
  exit 0
fi
{ [ -n "$CUR" ] && echo "$CUR"; echo "$JOB"; } | crontab -
echo "Scheduled: $JOB"
echo "Your crontab has $(crontab -l | grep -v -e '^[[:space:]]*$' -e '^[[:space:]]*#' | wc -l) jobs"

