# checker spec for s06 step 1 (see lib/engine.sh)
SCRIPT_NAME=countdown.sh
setup() { :; }
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *countdown.sh* ]]; }
ARGS=('3' '1' '5' '10')
COMPARE="stdout exit"
