# checker spec for 1525 (see lib/engine.sh)
SEEDS=4
setup() { local i; for i in $(seq "$(randr 2 9)"); do echo "$(pick '' '' '   ' '	')$(pick "$(words "$(randr 1 7)")" '' "$(word)  $(word)")"; done > texto.txt; }
extra_check() { must_not_use wc; must_use read; }
