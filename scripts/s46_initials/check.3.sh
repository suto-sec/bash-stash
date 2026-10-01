# checker spec for s46 step 3 (see lib/engine.sh)
SCRIPT_NAME=initials.sh
setup() { :; }
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *initials.sh* ]]; }
ARGS=('"ana maria ruiz"' '"ana maria" luis "Eva Gil"' 'x "a b c d"' '')
COMPARE="stdout exit errmsg"
extra_check() { [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }; }
