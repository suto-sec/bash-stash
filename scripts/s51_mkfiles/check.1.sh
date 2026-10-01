# checker spec for s51 step 1 (see lib/engine.sh)
SCRIPT_NAME=mkfiles.sh
setup() { echo old > report2; mkdir adir1; }
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *mkfiles.sh* ]]; }
ARGS=('log 3' 'x 1' '"my file" 2' 'data 12')
COMPARE="stdout exit files"
