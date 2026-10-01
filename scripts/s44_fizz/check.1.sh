# checker spec for s44 step 1 (see lib/engine.sh)
SCRIPT_NAME=fizz.sh
setup() { :; }
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *fizz.sh* ]]; }
ARGS=('1' '5' '15' '20')
COMPARE="stdout exit"
