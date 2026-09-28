# checker spec for 0501 (see lib/engine.sh)
setup() { randtext "$(randr 5 40)" > texto.txt; }
extra_check() { must_use wc; }
