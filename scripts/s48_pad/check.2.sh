# checker spec for s48 step 2 (see lib/engine.sh)
SCRIPT_NAME=pad.sh
setup() {
  mkfl small.txt "first line" "second line" "" "fourth  line  with  spaces"
  local i; for ((i = 1; i <= 12; i++)); do echo "row $i $(word)"; done > long.txt
  : > empty.txt; echo x > locked.txt; chmod 000 locked.txt; mkdir adir
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *pad.sh* ]]; }
ARGS=('small.txt' 'long.txt' '' 'small.txt long.txt' 'nothing.txt' 'adir' 'locked.txt')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == 2 ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
}
