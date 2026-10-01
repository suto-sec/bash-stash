# checker spec for s33 step 4 (see lib/engine.sh)
SCRIPT_NAME=menu.sh
setup() { :; }
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *menu.sh* ]]; }
ARGS=('upper hello' 'len ""' 'lower "A B"' 'upper' 'len' 'upper a b' 'reverse abc' 'reverse' '')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == 2 ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
  [[ $REF_CODE == 3 ]] && { usage_ok || fail "the message should show the correct usage"; }
}
