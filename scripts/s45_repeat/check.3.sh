# checker spec for s45 step 3 (see lib/engine.sh)
SCRIPT_NAME=repeat.sh
setup() { :; }
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *repeat.sh* ]]; }
ARGS=('hi 3' '-s hi 3' '-s "two words" 2' '-s x 1' '-s' '-s hi' '' '-s hi 0' '-s hi x' 'hi x')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == 2 ]] && mentions "$(eval "set -- $CASE"; echo "${@: -1}")"
}
