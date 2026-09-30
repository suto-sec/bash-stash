# checker spec for 1220 (see lib/engine.sh)
SCRIPT_NAME=job_summary.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() { local i; for i in 1 2 3 4 5 6; do randr 0 9; done > codes.txt; }
ARGS=('' '1' '3' '6' 'abc' '0' '7' '4 5')
extra_check() { must_use wait; }
