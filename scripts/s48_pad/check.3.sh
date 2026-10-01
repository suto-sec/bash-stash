# checker spec for s48 step 3 (see lib/engine.sh)
SCRIPT_NAME=pad.sh
setup() {
  mkfl small.txt "first line" "second line" "" "fourth  line  with  spaces"
  local i; for ((i = 1; i <= 12; i++)); do echo "row $i $(word)"; done > long.txt
  : > empty.txt; echo x > locked.txt; chmod 000 locked.txt; mkdir adir
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *pad.sh* ]]; }
ARGS=('small.txt' '-w 5 small.txt' '-w 1 long.txt' '-w 2 long.txt' '-w 9 small.txt' '-w 0 small.txt' '-w x small.txt' '-w 10 small.txt' '-w 5' '-w' '' 'nothing.txt' '-w 5 nothing.txt')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == 2 ]] && mentions "$(eval "set -- $CASE"; echo "${@: -1}")"
  [[ $REF_CODE == 3 ]] && mentions "$(eval "set -- $CASE"; echo "$2")"
}
