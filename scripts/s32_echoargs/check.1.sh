# checker spec for s32 step 1 (see lib/engine.sh)
SCRIPT_NAME=echoargs.sh
setup() { :; }
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *echoargs.sh* ]]; }
ARGS=('red' 'red green blue' '"dark blue" x' '')
COMPARE="stdout exit"
