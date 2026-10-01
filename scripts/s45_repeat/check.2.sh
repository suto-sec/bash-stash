# checker spec for s45 step 2 (see lib/engine.sh)
SCRIPT_NAME=repeat.sh
setup() { :; }
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *repeat.sh* ]]; }
ARGS=('hi 3' 'x 1' '' 'hi' 'a b c' 'hi 0' 'hi x' 'hi -2')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == 2 ]] && mentions "$(eval "set -- $CASE"; echo "$2")"
}
