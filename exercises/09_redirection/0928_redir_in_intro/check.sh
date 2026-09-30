# checker spec for 0928 (see lib/engine.sh)
SEEDS=1
setup() { local i; for i in $(seq "$(randr 2 6)"); do word; done > datos.txt; }
extra_check() { ans_code | grep -qE 'wc[^<|]*datos\.txt' && fail "pass the file with < (not as an argument)"; }
