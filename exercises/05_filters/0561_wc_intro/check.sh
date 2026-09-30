# checker spec for 0561 (see lib/engine.sh)
SEEDS=1
setup() { randtext "$(randr 5 20)" > texto.txt; }
extra_check() { must_use wc; }
