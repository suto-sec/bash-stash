# checker spec for s33 step 2 (see lib/engine.sh)
SCRIPT_NAME=menu.sh
setup() { :; }
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *menu.sh* ]]; }
ARGS=('upper hello' 'lower "Two WORDS"' 'len hello' 'len ""' 'len "two words"' 'upper ABC123')
COMPARE="stdout exit"
