# checker spec for 1338 (see lib/engine.sh)
SCRIPT_NAME=wrapper_capture.sh
SEEDS=2
COMPARE="stdout exit errmsg"
ARGS=('' 'echo hola' 'seq 1 3' 'echo' 'false' 'printf "a\nb"' 'ls /no/existe/aaa')
