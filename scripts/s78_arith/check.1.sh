# checker spec for s78 step 1 (see lib/engine.sh)
SCRIPT_NAME=arith.sh
setup() { mkdir -p dir; echo x > file.txt; }
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *arith.sh* ]]; }
ARGS=('7 + 5' '7 - 12' '7 x 6' '-4 x 5' '17 / 5' '-17 / 5' '17 % 5' '-17 % 5' '0 + 0' '100 / 7' '3 x -3')
COMPARE="stdout exit"
