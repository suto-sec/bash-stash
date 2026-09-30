# checker spec for 1332 (see lib/engine.sh)
SEEDS=1
COMPARE="stdout exit errmsg"
ARGS=('0 a b c' '1 a b c' '2 a b c' '3 a b c' '5 a b c d' 'abc a b' '-1 a b' '2' '0')
extra_check() { must_not_use "declare -a"; }
