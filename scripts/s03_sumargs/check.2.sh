# checker spec for s03 step 2 (see lib/engine.sh)
SCRIPT_NAME=sumargs.sh
setup() { :; }
ARGS=('' '5' '1 2 3' '10 20 30 40')
COMPARE="stdout exit errmsg"
extra_check() { [[ $REF_CODE == 1 ]] && { [[ $ERR == *sumargs.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the message should show the correct usage"; }; }
