# checker spec for s50 step 2 (see lib/engine.sh)
SCRIPT_NAME=grade.sh
setup() { :; }
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *grade.sh* ]]; }
ARGS=('95' '60' '0' '100' '' '1 2' 'abc' '101' '-5' '7.5' '1000')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == 2 ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
}
