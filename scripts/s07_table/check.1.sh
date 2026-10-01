# checker spec for s07 step 1 (see lib/engine.sh)
SCRIPT_NAME=table.sh
setup() { :; }
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *table.sh* ]]; }
ARGS=('7' '1' '12' '0' '25')
COMPARE="stdout exit"
