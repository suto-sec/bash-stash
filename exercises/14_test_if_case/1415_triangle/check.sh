# checker spec for 1415 (see lib/engine.sh)
SEEDS=1
SCRIPT_NAME=triangle.sh
COMPARE="stdout stderr exit"
ARGS=('3 3 3' '3 4 5' '5 3 4' '5 5 8' '2 3 4' '1 2 3' '1 1 5' '0 4 4' '6 8 10' '13 5 12' '10 6 8' '' '1 2' '1 2 x' '1 2 3 4' '-1 2 2' '4 4 7')
