# checker spec for s43 step 1 (see lib/engine.sh)
SCRIPT_NAME=maxnum.sh
setup() { :; }
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *maxnum.sh* ]]; }
ARGS=('5' '3 9 4' '-5 -2 -9' '10 10 10' '0 -1 7 7')
COMPARE="stdout exit"
