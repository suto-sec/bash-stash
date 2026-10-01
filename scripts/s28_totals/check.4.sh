# checker spec for s28 step 4 (see lib/engine.sh)
SCRIPT_NAME=totals.sh
setup() {
  local i
  for ((i = 0; i < $(randr 6 14); i++)); do echo "$(pick food rent fun travel):$(randr 1 300)"; done > sales.txt
  mkfl blanks.txt "food:10" "" "rent:500" "food:5" "" "fun:20"
  mkfl bad.txt "food:10" "rent:abc" "fun:20" "travel:5x"
  : > empty.txt; echo "x:1" > locked.txt; chmod 000 locked.txt; mkdir adir
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *totals.sh* ]]; }
ARGS=('sales.txt' 'blanks.txt' 'empty.txt' 'bad.txt' '' 'nothing.txt')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == 2 ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
  [[ $REF_CODE == 3 ]] && mentions "line 2"
}
