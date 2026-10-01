# checker spec for s31 step 2 (see lib/engine.sh)
SCRIPT_NAME=evenodd.sh
setup() { :; }
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *evenodd.sh* ]]; }
ARGS=('7' '10' '' '1 2' 'abc' '-4' '3.5')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == 2 ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
}
