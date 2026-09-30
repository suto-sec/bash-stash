# checker spec for 1034 (see lib/engine.sh)
SEEDS=1
setup() { local i; for i in $(seq "$(randr 2 9)"); do touch "$(word)$i"; done; }
extra_check() { must_use '\|'; }
