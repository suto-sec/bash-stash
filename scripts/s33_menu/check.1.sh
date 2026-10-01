# checker spec for s33 step 1 (see lib/engine.sh)
SCRIPT_NAME=menu.sh
setup() { :; }
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *menu.sh* ]]; }
ARGS=('upper hello' 'upper "two words"' 'upper ABC123')
COMPARE="stdout exit"
