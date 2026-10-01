# checker spec for s08 step 1 (see lib/engine.sh)
SCRIPT_NAME=vowels.sh
setup() { :; }
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *vowels.sh* ]]; }
ARGS=('Banana' 'rhythm' 'AEIOU' '"hello big world"' 'xyz123')
COMPARE="stdout exit"
