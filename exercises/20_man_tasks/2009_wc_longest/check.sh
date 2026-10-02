# checker spec for 2009 (see lib/engine.sh)
SEEDS=3
setup() { local i; for i in $(seq "$(randr 4 8)"); do words "$(randr 2 9)" | tr '\n' ' '; echo; done > poema.txt; }
extra_check() { must_use wc; }
