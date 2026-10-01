# checker spec for s46 step 1 (see lib/engine.sh)
SCRIPT_NAME=initials.sh
setup() { :; }
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *initials.sh* ]]; }
ARGS=('"ana maria ruiz"' 'luis' '"Eva Gil"' '"juan  carlos   perez"' '""')
COMPARE="stdout exit"
