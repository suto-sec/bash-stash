# checker spec for s01 step 3 (see lib/engine.sh)
SCRIPT_NAME=greet.sh
setup() { :; }
ARGS=('' 'Ana' '"Mary Ann"' 'Ana Bob' '1 2 3')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { [[ $ERR == *greet.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the message should show the correct usage"; }
}
