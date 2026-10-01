# checker spec for s45 step 1 (see lib/engine.sh)
SCRIPT_NAME=repeat.sh
setup() { :; }
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *repeat.sh* ]]; }
ARGS=('hi 3' '"two words" 2' 'x 1' 'a 6')
COMPARE="stdout exit"
