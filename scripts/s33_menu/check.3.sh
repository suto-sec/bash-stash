# checker spec for s33 step 3 (see lib/engine.sh)
SCRIPT_NAME=menu.sh
setup() { :; }
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *menu.sh* ]]; }
ARGS=('upper hello' 'lower HELLO' 'len abc' 'reverse abc' 'UPPER abc' '' 'x')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == 2 ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
}
