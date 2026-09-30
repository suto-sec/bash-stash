# checker spec for 1334 (see lib/engine.sh)
SEEDS=1
SCRIPT_NAME=retry_cmd.sh
COMPARE="stdout exit errmsg"
ARGS=('' '3' 'abc true' '0 true' '1 true' '3 true' '1 false' '4 false' '2 test 3 -eq 3' '2 test 3 -eq 4')
