# checker spec for s31 step 1 (see lib/engine.sh)
SCRIPT_NAME=evenodd.sh
setup() { :; }
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *evenodd.sh* ]]; }
ARGS=('7' '10' '0' '1' '123456')
COMPARE="stdout exit"
