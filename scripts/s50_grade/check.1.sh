# checker spec for s50 step 1 (see lib/engine.sh)
SCRIPT_NAME=grade.sh
setup() { :; }
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *grade.sh* ]]; }
ARGS=('95' '90' '89' '80' '75' '70' '65' '60' '59' '0' '100')
COMPARE="stdout exit"
