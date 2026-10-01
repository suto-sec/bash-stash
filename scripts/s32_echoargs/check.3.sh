# checker spec for s32 step 3 (see lib/engine.sh)
SCRIPT_NAME=echoargs.sh
setup() { :; }
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *echoargs.sh* ]]; }
ARGS=('red' 'red green blue' '-r red green blue' '-r "dark blue" x' '-r one' '-r' '')
COMPARE="stdout exit errmsg"
extra_check() { [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }; }
